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
static NSString * const kOMNMailRu_vterm_id = @"DGISMobile";
static NSString * const kOMNMailRu_secret_key = @"ohMDLYVUy0y8FKenvcVuPCYTtbeB7MI6qNOBxOCwSAmOoqwpXj";

static NSString * const kOMNMailRuAcquiringBaseURL = @"https://test-cpg.money.mail.ru/";

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
    
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"mydomain4" ofType:@"cer"];
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
- (void)registerCard:(NSString *)pan expDate:(NSString *)expDate cvv:(NSString *)cvv {
  
  pan = @"4111111111111111";
  expDate = @"12.2015";
  cvv = @"123";
  
  NSString *userLogin = @"1";
  NSString *userPhone = @"89833087335";
  
  NSDictionary *signatureParams =
  @{
    kOMNMailRu_merch_id : @"merch_id",
    kOMNMailRu_vterm_id : @"vterm_id",
    userLogin : @"user_login",
    };
  NSMutableArray *sortedSignatureParams = [[signatureParams keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    return [obj1 compare:obj2 options:NSLiteralSearch];
  }] mutableCopy];
  [sortedSignatureParams addObject:kOMNMailRu_secret_key];
  
  NSString *baseSignatureString = [sortedSignatureParams componentsJoinedByString:@""];
  
  NSString *signature = [baseSignatureString omn_sha1];
  
  NSDictionary *parameters =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : userLogin,
    @"user_phone" : userPhone,
    @"signature" : signature,
    @"pan" : pan,
    @"exp_date" : expDate,
    @"cvv" : cvv,
    @"cardholder" : @"Omnom",
    };
  
  [self POST:@"api/card/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  //  [operation setWillSendRequestForAuthenticationChallengeBlock:^(NSURLConnection *connection, NSURLAuthenticationChallenge *challenge) {
  //
  //    NSLog(@"%@", challenge);
  //
  //  }];
  
}

- (void)pay {
  
  NSDictionary *extra =
  @{
    @"tip" : @(12332),
    };
  
  NSError *error = nil;
  NSData *extraJSONData = [NSJSONSerialization dataWithJSONObject:extra options:0 error:&error];
  if (error) {
    NSLog(@"%@", error);
    return;
  }
  
  NSString *order_id = @"123";
  NSString *user_login = @"89833087335";
  NSString *user_phone = @"89833087335";
  NSString *pan = @"4111111111111111";
  NSString *expDate = @"12.2015";
  NSString *cvv = @"123";
  NSString *order_amount = @"526.06";
  NSString *order_message = @"message";
  
  NSString *extratext = [[NSString alloc] initWithData:extraJSONData encoding:NSUTF8StringEncoding];
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : user_login,
    @"order_id" : order_id,
    @"order_amount" : order_amount,
    @"order_message" : order_message,
    @"extra" : extratext,
    };
  
  NSString *signature = [reqiredSignatureParams omn_signature];
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = signature;
  parameters[@"pan"] = pan;
  parameters[@"cardholder"] = @"Omnom";
  parameters[@"exp_date"] = expDate;
  parameters[@"cvv"] = cvv;
  parameters[@"add_card"] = @(1);
  parameters[@"user_phone"] = user_phone;
  
  [self POST:@"api/order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    if (responseObject[@"url"]) {
      
      [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
      }];
      
    }
    
    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    
    
    
    NSLog(@"%@", responseObject);
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  
  
}

@end

@implementation NSString (omn_mailRu)

- (NSString *)omn_sha1 {
  
  NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
  uint8_t digest[CC_SHA1_DIGEST_LENGTH];
  
  CC_SHA1(data.bytes, data.length, digest);
  
  NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
  
  for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
    [output appendFormat:@"%02x", digest[i]];
  }
  
  return output;
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
  
  NSString *signature = [baseSignatureString omn_sha1];
  
  return signature;
}

@end