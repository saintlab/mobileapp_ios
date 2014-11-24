//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"
#import <CommonCrypto/CommonDigest.h>

static NSDictionary *_config = nil;

@interface AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse;

@end

@interface NSString (omn_mailRu)

- (NSString *)omn_sha1;

@end

@interface NSDictionary (omn_mailRu)

- (NSString *)omn_signature;

@end

@implementation OMNMailRuAcquiring

+ (NSDictionary *)config {
  return _config;
}

+ (instancetype)acquiring {
  
  if (nil == _config) {
    [self setConfig:
     @{
       @"OMNMailRu_merch_id" : @"DGIS",
       @"OMNMailRu_vterm_id" : @"DGISMobile",
       @"OMNMailRu_cardholder" : @"Omnom",
       @"OMNMailRu_secret_key" : @"qmluSZ1HkWQRWkUtcDOM",
       @"OMNMailRuAcquiringBaseURL" : @"https://cpg.money.mail.ru/api/",
       @"OMNMailRuTestCVV" : @"",
       }];
  }
  
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    NSString *urlString = _config[@"OMNMailRuAcquiringBaseURL"];
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:urlString]];
  });
  return manager;
}

+ (BOOL)isValidConfig:(NSDictionary *)config {
  
  if (config[@"OMNMailRu_merch_id"] &&
      config[@"OMNMailRu_vterm_id"] &&
      config[@"OMNMailRu_cardholder"] &&
      config[@"OMNMailRu_secret_key"] &&
      config[@"OMNMailRuAcquiringBaseURL"]) {
    return YES;
  }
  else {
    return NO;
  }
  
}

+ (void)setConfig:(NSDictionary *)config {
  
  if ([self isValidConfig:config]) {
    _config = config;
  }

}

+ (NSDictionary *)configWithName:(NSString *)name {
  NSData *data = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:name ofType:@"json"]];
  NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
  return config;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {

    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.requestSerializer.timeoutInterval = 15.0;
    
  }
  return self;
}

- (NSString *)testCVV {
  return _config[@"OMNMailRuTestCVV"];
}

/*
 merch_id идентификатор мерчанта, выданный при подключении мерчанта
 
 vterm_id идентификатор виртуального терминала, через который будет
 
 user_login логин пользователя, к которому нужно привязать карту
 
 user_phone телефон пользователя
 
 user_ip IP-адрес пользователя
 
 backurl URL возврата в магазин
 
 extra дополнительные данные в формате JSON
 
 language язык (по умолчанию - русский)
 
 signature цифровая подпись параметров запроса
 
 Данные карты.
 
 pan номер карты
 
 exp_date дата истечения срока действия карты
 
 cvv код подтверждения на оборотной стороне карты
 
 cardholder имя держателя карты
 */
- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(id response, NSString *cardId))completionBlock {
  
  NSAssert(completionBlock != nil, @"registerCard completionBlock is nil");
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config[@"OMNMailRu_merch_id"],
    @"vterm_id" : _config[@"OMNMailRu_vterm_id"],
    @"user_login" : user_login,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"cardholder"] = _config[@"OMNMailRu_cardholder"];
  parameters[@"user_phone"] = user_phone;

  [parameters addEntriesFromDictionary:cardInfo];
  
  __weak typeof(self)weakSelf = self;
  [self POST:@"card/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"url"]) {
      
      [weakSelf checkRegisterForResponse:responseObject withCompletion:completionBlock];

    }
    else {

      completionBlock(responseObject, nil);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    completionBlock([operation omn_errorResponse], nil);
    
  }];
  
}

- (void)checkRegisterForResponse:(id)response withCompletion:(void(^)(id response, NSString *cardId))completionBlock {
  
  __weak typeof(self)weakSelf = self;
  NSString *url = response[@"url"];
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf checkRegisterForResponse:response withCompletion:completionBlock];
      });
    }
    else {
      
      completionBlock(responseObject, response[@"card_id"]);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock([operation omn_errorResponse], response[@"card_id"]);
    
  }];
  
}

NSError *errorWithCode(OMNMailRuErrorCode code) {
  
  return [NSError errorWithDomain:@"OMNMailRuError" code:code userInfo:nil];
  
}

- (void)cardVerify:(double)amount user_login:(NSString *)user_login card_id:(NSString *)card_id completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock {
  
  NSAssert(completionBlock != nil, @"cardVerify completionBlock is nil");
  NSAssert(failureBlock != nil, @"cardVerify failureBlock is nil");
  
  if (amount <= 0.0l) {
    failureBlock(errorWithCode(kOMNMailRuErrorCodeCardAmount), nil);
    return;
  }

  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config[@"OMNMailRu_merch_id"],
    @"vterm_id" : _config[@"OMNMailRu_vterm_id"],
    @"user_login" : user_login,
    @"card_id" : card_id,
    };

  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"amount"] = @(amount);
  
  __weak typeof(self)weakSelf = self;
  
  NSMutableDictionary *debugInfo = [NSMutableDictionary dictionaryWithObject:parameters forKey:@"request"];
  
  [self POST:@"card/verify" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (responseObject) {
      debugInfo[@"response"] = responseObject;
    }
    
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      
      if (nil == responseObject[@"error"]) {
        
        completionBlock();
        
      }
      else {
        
        NSString *code = responseObject[@"error"][@"code"];
        if ([code isKindOfClass:[NSString class]] &&
            [code isEqualToString:@"ERR_CARD_AMOUNT"]) {
          
          failureBlock(errorWithCode(kOMNMailRuErrorCodeCardAmount), debugInfo);
          
        }
        else {
          
          failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), debugInfo);
          
        }
        
      }
      
    }
    else {
      
      failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), debugInfo);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    if (error.localizedDescription) {
      debugInfo[@"response"] = error.localizedDescription;
    }
    failureBlock(error, debugInfo);
    
  }];
  
}

- (void)pollUrl:(NSString *)url withCompletion:(void(^)(id response))completionBlock {
  
  __weak typeof(self)weakSelf = self;
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"\npollUrl:>\n%@", responseObject);
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf pollUrl:url withCompletion:completionBlock];
        
      });
    }
    else {
      
      completionBlock(responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock([operation omn_errorResponse]);
    
  }];
  
}

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock {
  
  NSString *extratext = paymentInfo.extra.extra_text;
  if (0 == extratext.length) {
    failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), nil);
    return;
  }
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config[@"OMNMailRu_merch_id"],
    @"vterm_id" : _config[@"OMNMailRu_vterm_id"],
    @"user_login" : paymentInfo.user_login,
    @"order_id" : paymentInfo.order_id,
    @"order_amount" : paymentInfo.order_amount,
    @"order_message" : paymentInfo.order_message,
    @"extra" : extratext,
    };
  
  NSString *signature = [reqiredSignatureParams omn_signature];
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = signature;
  NSDictionary *card_info = [paymentInfo.cardInfo card_info];
  [parameters addEntriesFromDictionary:card_info];

  parameters[@"cardholder"] = _config[@"OMNMailRu_cardholder"];
  parameters[@"user_phone"] = paymentInfo.user_phone;
  
  __weak typeof(self)weakSelf = self;
  [self POST:@"order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (responseObject[@"url"] &&
        nil == responseObject[@"error"]) {
      
      [weakSelf pollUrl:responseObject[@"url"] withCompletion:^(id response) {
        
        NSString *status = response[@"status"];
        NSString *order_status = response[@"order_status"];
        if ([status isEqualToString:@"OK_FINISH"] &&
            [order_status isEqualToString:@"PAID"]) {
          
          completionBlock(responseObject);
          
        }
        else {
          
          failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), parameters);
          
        }
        
      }];
      
    }
    else {

      failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), parameters);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters);
    
  }];
  
}

- (void)cardDelete:(NSString *)card_id user_login:(NSString *)user_login completion:(void(^)(id response))completionBlock {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config[@"OMNMailRu_merch_id"],
    @"vterm_id" : _config[@"OMNMailRu_vterm_id"],
    @"user_login" : user_login,
    @"card_id" : card_id,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  
  [self POST:@"card/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    completionBlock(responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    completionBlock([operation omn_errorResponse]);
    
  }];
  
}

@end

@implementation NSString (omn_mailRu)

- (NSString *)omn_sha1 {
  
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
  
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [output appendFormat:@"%02x", digest[i]];
  }
  
  return [output copy];
  
}

@end

@implementation NSDictionary (omn_mailRu)

- (NSString *)omn_signature {
  
  NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSMutableArray *sortedValues = [NSMutableArray arrayWithCapacity:sortedKeys.count + 1];
  [sortedKeys enumerateObjectsUsingBlock:^(id sortedKey, NSUInteger idx, BOOL *stop) {
    
    [sortedValues addObject:self[sortedKey]];
    
  }];
  [sortedValues addObject:_config[@"OMNMailRu_secret_key"]];
  
  NSString *baseSignatureString = [sortedValues componentsJoinedByString:@""];
  NSString *signature = [baseSignatureString omn_sha1];

  
  return signature;
}

@end

@implementation AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse {
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"error"] = (self.error.localizedDescription) ? (self.error.localizedDescription) : (@"");
  if (self.responseString) {
    parametrs[@"response_string"] = self.responseString;
  }
  return parametrs;
}

@end