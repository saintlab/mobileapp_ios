//
//  OMNMailRuPaymentInfo.m
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import "OMNMailRuPaymentInfo.h"
#import "OMNMailRuAcquiring.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString (omn_mailRu)

- (NSString *)omn_sha1;

@end

@implementation OMNMailRuPaymentInfo

- (instancetype)init {
  self = [super init];
  if (self) {
    self.order_id = @"";
    self.user_phone = @"";
    self.order_amount = @"";
    self.order_message = @"";
    self.user_login = @"";
    self.extra = [[OMNMailRuExtra alloc] init];
    self.cardInfo = [[OMNMailRuCardInfo alloc] init];
  }
  return self;
}

- (NSDictionary *)payParametersWithConfig:(OMNMailRuConfig *)config {
  
  NSString *extratext = self.extra.extra_text;
  if (0 == extratext.length ||
      !config.isValid) {
    return nil;
  }

  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : config.merch_id,
    @"vterm_id" : config.vterm_id,
    @"user_login" : self.user_login,
    @"order_id" : self.order_id,
    @"order_amount" : self.order_amount,
    @"order_message" : self.order_message,
    @"extra" : extratext,
    };
  
  NSString *signature = [reqiredSignatureParams omn_mailRuSignatureWithSecret:config.secret_key];
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = signature;
  NSDictionary *card_info = [self.cardInfo card_info];
  [parameters addEntriesFromDictionary:card_info];
  
  parameters[@"cardholder"] = config.cardholder;
  parameters[@"user_phone"] = self.user_phone;
  return [parameters copy];
  
}

@end

@implementation OMNMailRuExtra

- (instancetype)init {
  self = [super init];
  if (self) {
    self.restaurant_id = @"";
    self.type = @"";
  }
  return self;
}

- (NSString *)extra_text {
  
  if (!self.restaurant_id) {
    return nil;
  }
  
  NSDictionary *extra =
  @{
    @"tip" : @(self.tip),
    @"restaurant_id" : self.restaurant_id,
    @"type" : self.type,
    };
  
  NSError *error = nil;
  NSData *extraJSONData = [NSJSONSerialization dataWithJSONObject:extra options:0 error:&error];
  if (error) {
    NSLog(@"extra_text>%@", error);
    return nil;
  }

  NSString *extra_text = [[NSString alloc] initWithData:extraJSONData encoding:NSUTF8StringEncoding];
  return extra_text;
  
}

@end

@implementation OMNMailRuCardInfo

- (instancetype)init {
  self = [super init];
  if (self) {
    self.pan = @"";
    self.exp_date = @"";
    self.cvv = @"";
    self.card_id = @"";
  }
  return self;
}

+ (NSString *)exp_dateFromMonth:(NSInteger)month year:(NSInteger)year {
  return [NSString stringWithFormat:@"%2ld.20%2ld", (long)month, (long)year];
}

+ (OMNMailRuCardInfo *)cardInfoWithCardId:(NSString *)card_id {
  OMNMailRuCardInfo *cardInfo = [[OMNMailRuCardInfo alloc] init];
  cardInfo.card_id = card_id;
  return cardInfo;
}

+ (OMNMailRuCardInfo *)cardInfoWithCardPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv {
  OMNMailRuCardInfo *cardInfo = [[OMNMailRuCardInfo alloc] init];
  cardInfo.pan = pan;
  cardInfo.exp_date = exp_date;
  cardInfo.cvv = cvv;
  return cardInfo;
}

- (NSDictionary *)card_info {
  
  NSMutableDictionary *card_info = [NSMutableDictionary dictionary];
  
  if (self.card_id.length) {
    card_info[@"card_id"] = self.card_id;
  }
  else {

    if (self.pan.length) {
      card_info[@"pan"] = self.pan;
    }
    if (self.exp_date.length) {
      card_info[@"exp_date"] = self.exp_date;
    }
    card_info[@"add_card"] = @(self.add_card);
  }
  
  if (self.cvv.length) {
    card_info[@"cvv"] = self.cvv;
  }
  
  return card_info;
}

@end

@implementation NSDictionary (omn_mailRu)

- (NSString *)omn_mailRuSignatureWithSecret:(NSString *)secret_key; {
  
  NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(compare:)];
  NSMutableArray *sortedValues = [NSMutableArray arrayWithCapacity:sortedKeys.count + 1];
  [sortedKeys enumerateObjectsUsingBlock:^(id sortedKey, NSUInteger idx, BOOL *stop) {
    
    [sortedValues addObject:self[sortedKey]];
    
  }];
  [sortedValues addObject:secret_key];
  
  NSString *baseSignatureString = [sortedValues componentsJoinedByString:@""];
  NSString *signature = [baseSignatureString omn_sha1];
  return signature;
  
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


@implementation OMNMailRuConfig

- (instancetype)initWithParametrs:(NSDictionary *)parametrs {
  self = [super init];
  if (self) {
    
    _merch_id = parametrs[@"OMNMailRu_merch_id"];
    _vterm_id = parametrs[@"OMNMailRu_vterm_id"];
    _secret_key = parametrs[@"OMNMailRu_secret_key"];
    _cardholder = parametrs[@"OMNMailRu_cardholder"];
    _baseURL = parametrs[@"OMNMailRuAcquiringBaseURL"];
    
  }
  return self;
}

- (BOOL)isValid {
  
  return
  (
   self.merch_id &&
   self.vterm_id &&
   self.secret_key &&
   self.baseURL &&
   self.cardholder
   );
  
}

+ (instancetype)configWithParametrs:(NSDictionary *)parametrs {
  return [[OMNMailRuConfig alloc] initWithParametrs:parametrs];
}

@end