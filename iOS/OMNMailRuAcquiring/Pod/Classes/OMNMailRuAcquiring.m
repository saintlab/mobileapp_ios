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
static NSString * const kOMNMailRu_cardholder = @"Omnom";
static NSString * const kOMNMailRu_secret_key = @"ohMDLYVUy0y8FKenvcVuPCYTtbeB7MI6qNOBxOCwSAmOoqwpXj";

static NSString * const kOMNMailRu_user_login = @"2";

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
- (void)registerCard:(NSDictionary *)cardInfo user_login:(NSString *)user_login user_phone:(NSString *)user_phone completion:(void(^)(id response))completion {
  
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
  
  NSString *extratext = [[NSString alloc] initWithData:extraJSONData encoding:NSUTF8StringEncoding];
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : user_login,
    @"extra" : extratext,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"cardholder"] = kOMNMailRu_cardholder;
  parameters[@"user_phone"] = user_phone;

  [parameters addEntriesFromDictionary:cardInfo];
  
  [self POST:@"card/register" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", responseObject);
    
    if (responseObject[@"url"]) {
      if (completion) {
        completion(responseObject);
      }

      [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
      }];
      
    }
    else {
      if (completion) {
        completion(nil);
      }
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    if (completion) {
      completion(nil);
    }
    
  }];
  
}

- (void)cardVerify:(double)amount card_id:(NSString *)card_id {
  
  amount = 1.04;
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : kOMNMailRu_user_login,
    @"card_id" : card_id,
    };

  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  parameters[@"amount"] = @(amount);
  
  [self POST:@"card/verify" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", responseObject);
    
    if (responseObject[@"url"]) {
      
      [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
      }];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
}

- (void)payWithCardInfo:(NSDictionary *)cardInfo addCard:(BOOL)addCard {
  
  NSDictionary *extra =
  @{
    @"tip" : @(12332),
    @"restaurant_id" : @"1",
    };
  
  NSError *error = nil;
  NSData *extraJSONData = [NSJSONSerialization dataWithJSONObject:extra options:0 error:&error];
  if (error) {
    NSLog(@"%@", error);
    return;
  }
  
  NSString *order_id = @"1234";
  NSString *user_phone = @"89833087336";
  NSString *order_amount = @"526.07";
  NSString *order_message = @"message1";
  
  NSString *extratext = [[NSString alloc] initWithData:extraJSONData encoding:NSUTF8StringEncoding];
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : kOMNMailRu_user_login,
    @"order_id" : order_id,
    @"order_amount" : order_amount,
    @"order_message" : order_message,
    @"extra" : extratext,
    };
  
  NSString *signature = [reqiredSignatureParams omn_signature];
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = signature;
  [parameters addEntriesFromDictionary:cardInfo];

  parameters[@"cardholder"] = kOMNMailRu_cardholder;
  if (addCard) {
    parameters[@"add_card"] = @(1);
  }
  parameters[@"user_phone"] = user_phone;
  
  [self POST:@"order/pay" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    NSLog(@"%@", responseObject);
    
    if (responseObject[@"url"]) {
      
      [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
      }];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
  
  
}

- (void)cardDelete:(NSString *)card_id {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : kOMNMailRu_merch_id,
    @"vterm_id" : kOMNMailRu_vterm_id,
    @"user_login" : kOMNMailRu_user_login,
    @"card_id" : card_id,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_signature];
  
  [self POST:@"card/delete" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
    NSLog(@"%@", responseObject);
    NSLog(@"%@", [[NSString alloc] initWithData:operation.request.HTTPBody encoding:NSUTF8StringEncoding]);
    if (responseObject[@"url"]) {
      
      [self GET:responseObject[@"url"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@", responseObject);
        
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@", error);
        
      }];
      
    }
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"%@", error);
    
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