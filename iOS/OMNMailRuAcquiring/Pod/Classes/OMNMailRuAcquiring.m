//
//  OMNMailRuAcquiring.m
//  OMNMailRuAcquiring
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNMailRuAcquiring.h"
#import <CommonCrypto/CommonDigest.h>

static NSString * const kOMNMailRu_merch_id = @"DGIS";
//static NSString * const kOMNMailRu_vterm_id = @"DGISMobile";
static NSString * const kOMNMailRu_vterm_id = @"DGISMobileDemo";
static NSString * const kOMNMailRu_cardholder = @"Omnom";
static NSString * const kOMNMailRu_secret_key = @"ohMDLYVUy0y8FKenvcVuPCYTtbeB7MI6qNOBxOCwSAmOoqwpXj";

static NSString * const kOMNMailRuAcquiringBaseURL = @"https://test-cpg.money.mail.ru/api/";

@interface NSString (omn_mailRu)

- (NSString *)omn_sha1;

@end

@interface NSDictionary (omn_mailRu)

- (NSString *)omn_signature;

@end

@implementation OMNMailRuAcquiring

+ (instancetype)acquiring {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:kOMNMailRuAcquiringBaseURL]];
  });
  return manager;
}

- (instancetype)initWithBaseURL:(NSURL *)url {
  self = [super initWithBaseURL:url];
  if (self) {
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mail.ru" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
    [securityPolicy setAllowInvalidCertificates:NO];
    [securityPolicy setPinnedCertificates:@[certData]];
    securityPolicy.validatesCertificateChain = NO;
    [securityPolicy setSSLPinningMode:AFSSLPinningModeCertificate];
    
    self.securityPolicy = securityPolicy;
    
  }
  return self;
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
- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(id response))completion {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : user_login,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"cardholder"] = kOMNMailRu_cardholder;
  parameters[@"user_phone"] = user_phone;

  [parameters addEntriesFromDictionary:cardInfo];
  
  [self POST:@"card/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"card/register>%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"card/register>%@", responseObject);
    
    if (responseObject[@"url"]) {
      if (completion) {
        completion(responseObject);
      }
      
    }
    else {
      if (completion) {
        completion(nil);
      }
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"card/register>%@", error);
    NSLog(@"card/register>%@", operation.responseString);
    if (completion) {
      completion(nil);
    }
    
  }];
  
}

- (void)cardVerify:(double)amount user_login:(NSString *)user_login card_id:(NSString *)card_id completion:(void(^)(id response))completion {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : user_login,
    @"card_id" : card_id,
    };

  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"amount"] = @(amount);
  
  [self POST:@"card/verify" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"card/verify>%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"card/verify>%@", responseObject);
    
    completion(responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"card/verify>%@", error);
    NSLog(@"card/verify>%@", operation.responseString);
    completion(nil);
    
  }];
  
}

- (void)payWithInfo:(OMNMailRuPaymentInfo *)paymentInfo completion:(void(^)(id response))completionBlock {
  
  NSString *extratext = paymentInfo.extra.extra_text;
  if (0 == extratext.length) {
    completionBlock(nil);
    return;
  }
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
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

  parameters[@"cardholder"] = kOMNMailRu_cardholder;
  parameters[@"user_phone"] = paymentInfo.user_phone;
  
  [self POST:@"order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"order/payHTTPBody>%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"order/payresponse>%@", responseObject);
    
    [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      NSLog(@"%@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      NSLog(@"%@", operation.responseString);
    }];
    
    completionBlock(responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"order/pay>%@", error);
    NSLog(@"order/pay>%@", operation.responseString);

    completionBlock(nil);
    
  }];
  
  
  
}

- (void)cardDelete:(NSString *)card_id user_login:(NSString *)user_login completion:(void(^)(id response))completionBlock {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : user_login,
    @"card_id" : card_id,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  
  [self POST:@"card/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"card/delete>%@", responseObject);
    NSLog(@"card/delete>%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"card/delete>%@", operation.responseString);
    completionBlock(responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"card/delete>%@", error);
    NSLog(@"card/delete>%@", operation.responseString);
    completionBlock(nil);
    
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
  [sortedValues addObject:kOMNMailRu_secret_key];
  
  NSString *baseSignatureString = [sortedValues componentsJoinedByString:@""];
  NSLog(@"baseSignatureString>%@", baseSignatureString);
  NSString *signature = [baseSignatureString omn_sha1];

  
  return signature;
}

@end