//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"
#import <CommonCrypto/CommonDigest.h>

NSString *const OMNMailRuErrorDomain = @"OMNMailRuErrorDomain";

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
       @"OMNMailRu_secret_key" : @"5FEgXKDjuaegndwVJugNVUTMov8AXR7kY6CFLdivveDpxn5XmF",
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
    
    NSMutableDictionary *cfg = [config mutableCopy];
//    cfg[@"OMNMailRu_vterm_id"] = @"DGISMobile2";
//#warning 123
    _config = cfg;
    
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

- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(NSString *cardId))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
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
      
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf checkCardRegisterResponse:responseObject withCompletion:completionBlock failure:failureBlock];
      
    }
    else {
      
      failureBlock(nil, parameters, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters, nil);
    
  }];
  
}

- (void)checkCardRegisterResponse:(id)response withCompletion:(void(^)(NSString *cardId))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  NSString *url = response[@"url"];
  NSString *cardID = response[@"card_id"];
  
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf checkCardRegisterResponse:response withCompletion:completionBlock failure:failureBlock];
        
      });
      
    }
    else if([status isEqualToString:@"OK_FINISH"] &&
            cardID) {
      
      completionBlock(cardID);
      
    }
    else {
      
      failureBlock([NSError omn_errorFromResponse:responseObject], response, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, response, nil);
    
  }];
  
}

NSError *errorWithCode(OMNMailRuErrorCode code) {
  
  return [NSError errorWithDomain:OMNMailRuErrorDomain code:code userInfo:nil];
  
}

- (void)verifyCard:(NSString *)card_id user_login:(NSString *)user_login amount:(double)amount completion:(dispatch_block_t)completionBlock  failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSAssert(completionBlock != nil, @"cardVerify completionBlock is nil");
  NSAssert(failureBlock != nil, @"cardVerify failureBlock is nil");
  
  if (amount <= 0.0) {
    failureBlock(errorWithCode(kOMNMailRuErrorCodeCardAmount), nil, nil);
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
  
  [self POST:@"card/verify" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

    if (responseObject[@"error"]) {
      
      failureBlock([NSError omn_errorFromResponse:responseObject], parameters, responseObject);
      
    }
    else {
      
      completionBlock();
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters, nil);
    
  }];
  
}

- (void)pollUrl:(NSString *)url withCompletion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  __weak typeof(self)weakSelf = self;
  [self GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSString *status = responseObject[@"status"];
    if ([status isEqualToString:@"OK_CONTINUE"]) {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf pollUrl:url withCompletion:completionBlock failure:failureBlock];
        
      });
    }
    else {
      
      completionBlock(responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
  
}

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSString *extratext = paymentInfo.extra.extra_text;
  if (0 == extratext.length) {
    failureBlock(errorWithCode(kOMNMailRuErrorCodeUnknown), nil, nil);
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

    NSString *url = responseObject[@"url"];
    if (url &&
        nil == responseObject[@"error"]) {
      
      __strong __typeof(weakSelf)strongSelf = weakSelf;
      [strongSelf pollUrl:url withCompletion:^(id response) {
        
        NSString *status = response[@"status"];
        NSString *order_status = response[@"order_status"];
        if ([status isEqualToString:@"OK_FINISH"] &&
            [order_status isEqualToString:@"PAID"]) {
          
          completionBlock(response);
          
        }
        else {
          
          failureBlock([NSError omn_errorFromResponse:responseObject], parameters, responseObject);
          
        }
        
      } failure:^(NSError *error) {
        
        failureBlock(error, responseObject, nil);
        
      }];

    }
    else {

      failureBlock([NSError omn_errorFromResponse:responseObject], parameters, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error, parameters, nil);
    
  }];
  
  
}

- (void)deleteCard:(NSString *)card_id user_login:(NSString *)user_login сompletion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *request, NSDictionary *response))failureBlock {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : _config[@"OMNMailRu_merch_id"],
    @"vterm_id" : _config[@"OMNMailRu_vterm_id"],
    @"card_id" : card_id,
    @"user_login" : user_login,
    };
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];

  [self POST:@"card/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if ([responseObject[@"status"] isEqualToString:@"OK"]) {
      
      completionBlock();
      
    }
    else {
      
      failureBlock([NSError omn_errorFromResponse:responseObject], parameters, responseObject);
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

    failureBlock(error, parameters, nil);
    
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

@implementation NSError (mailRuError)

+ (NSError *)omn_errorFromResponse:(id)response {
  
  if (![response isKindOfClass:[NSDictionary class]]) {
    return [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil];
  }
  
  NSError *error = nil;
  if (response[@"error"]) {
    
    NSString *description = response[@"error"][@"descr"];
    NSString *codeString = response[@"error"][@"code"];
    if (description) {
      
      NSInteger code = kOMNMailRuErrorCodeDefault;
      if ([codeString isEqualToString:@"ERR_CARD_AMOUNT"]) {
        
        code = kOMNMailRuErrorCodeCardAmount;
        
      }
      
      error = [NSError errorWithDomain:OMNMailRuErrorDomain
                                  code:code
                              userInfo:
               @{
                 NSLocalizedDescriptionKey : description,
                 }];
      
    }
    else {
      
      error = [NSError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:nil];
      
    }
    
  }
  
  return error;
  
}

@end