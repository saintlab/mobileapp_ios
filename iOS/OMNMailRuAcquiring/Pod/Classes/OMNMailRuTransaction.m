//
//  OMNMailRuPaymentInfo.m
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import "OMNMailRuTransaction.h"
#import "OMNMailRuAcquiring.h"
#import <CommonCrypto/CommonDigest.h>

@interface NSString (omn_mailRu)

- (NSString *)omn_sha1;

@end

@implementation OMNMailRuTransaction

- (instancetype)initWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user order:(OMNMailRuOrder *)order extra:(OMNMailRuExtra *)extra {
  self = [super init];
  if (self) {
    
    _extra = extra;
    _card = card;
    _order = order;
    _extra = extra;
    
  }
  return self;
}

+ (instancetype)registerTransactionWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user {
  return [[OMNMailRuTransaction alloc] initWithCard:card user:user order:nil extra:nil];
}

+ (instancetype)registerTransactionWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user {

  OMNMailRuCard *card = [OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv];
  return [[OMNMailRuTransaction alloc] initWithCard:card user:user order:nil extra:nil];
  
}

+ (instancetype)payAndRegisterTransactionWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user {
  
  OMNMailRuCard *card = [OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv];
  card.add_card = YES;
  OMNMailRuOrder *order = [OMNMailRuOrder orderWithID:@"0" amount:@(1)];
  return [[OMNMailRuTransaction alloc] initWithCard:card user:user order:order extra:nil];
  
}

+ (instancetype)payTransactionWithCard:(OMNMailRuCard *)card user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount {
  return [[OMNMailRuTransaction alloc] initWithCard:card user:user order:[OMNMailRuOrder orderWithID:order_id amount:order_amount] extra:nil];
}

+ (instancetype)payTransactionWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount {
  
  OMNMailRuCard *card = [OMNMailRuCard cardWithPan:pan exp_date:exp_date cvv:cvv];
  OMNMailRuOrder *order = [OMNMailRuOrder orderWithID:order_id amount:order_amount];
  return [[OMNMailRuTransaction alloc] initWithCard:card user:user order:order extra:nil];

}

+ (instancetype)verifyTransactionWithCardID:(NSString *)cardID user:(OMNMailRuUser *)user amount:(NSNumber *)amount {
  return [[OMNMailRuTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:[OMNMailRuOrder orderWithID:@"" amount:amount] extra:nil];
}

+ (instancetype)deleteTransactionWithCardID:(NSString *)cardID user:(OMNMailRuUser *)user {
  return [[OMNMailRuTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:nil extra:nil];
}

+ (instancetype)payTransactionWithCardID:(NSString *)cardID user:(OMNMailRuUser *)user order_id:(NSString *)order_id order_amount:(NSNumber *)order_amount {
  return [[OMNMailRuTransaction alloc] initWithCard:[OMNMailRuCard cardWithID:cardID] user:user order:[OMNMailRuOrder orderWithID:order_id amount:order_amount] extra:nil];
}

- (NSDictionary *)payParametersWithConfig:(OMNMailRuConfig *)config {
  
  NSString *extratext = self.extra.text;
  if (0 == extratext.length ||
      !config.isValid) {
    return nil;
  }

  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : config.merch_id,
    @"vterm_id" : config.vterm_id,
    @"user_login" : self.user.login,
    @"order_id" : self.order.id,
    @"order_amount" : self.order.amount,
    @"extra" : extratext,
    };
  
  NSString *signature = [reqiredSignatureParams omn_mailRuSignatureWithSecret:config.secret_key];
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = signature;
  [parameters addEntriesFromDictionary:self.card.parameters];
  
  parameters[@"cardholder"] = config.cardholder;
  parameters[@"user_phone"] = self.user.phone;
  return [parameters copy];
  
}

- (NSDictionary *)registerCardParametersWithConfig:(OMNMailRuConfig *)config {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : config.merch_id,
    @"vterm_id" : config.vterm_id,
    @"user_login" : self.user.login,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:config.secret_key];
  parameters[@"cardholder"] = config.cardholder;
  parameters[@"user_phone"] = self.user.phone;
  [parameters addEntriesFromDictionary:self.card.parameters];
  return [parameters copy];
  
}

- (NSDictionary *)verifyCardParametersWithConfig:(OMNMailRuConfig *)config {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : config.merch_id,
    @"vterm_id" : config.vterm_id,
    @"user_login" : self.user.login,
    @"card_id" : self.card.id,
    };
  
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:config.secret_key];
  parameters[@"amount"] = self.order.amount;
  return [parameters copy];
  
}

- (NSDictionary *)deleteCardParameterWithConfig:(OMNMailRuConfig *)config {
  
  NSDictionary *reqiredSignatureParams =
  @{
    @"merch_id" : config.merch_id,
    @"vterm_id" : config.vterm_id,
    @"card_id" : self.card.id,
    @"user_login" : self.user.login,
    };
  NSMutableDictionary *parameters = [reqiredSignatureParams mutableCopy];
  parameters[@"signature"] = [reqiredSignatureParams omn_mailRuSignatureWithSecret:config.secret_key];
  return [parameters copy];
  
}

@end

@implementation OMNMailRuOrder

- (instancetype)initWithID:(NSString *)id amount:(NSNumber *)amount {
  self = [super init];
  if (self) {
    _id = id;
    _amount = amount;
  }
  return self;
}

+ (instancetype)orderWithID:(NSString *)id amount:(NSNumber *)amount {
  return [[OMNMailRuOrder alloc] initWithID:id amount:amount];
}

@end

@implementation OMNMailRuExtra

+ (instancetype)extraWithRestaurantID:(NSString *)restaurantID tipAmount:(long long)tipAmount type:(NSString *)type {
  return [[OMNMailRuExtra alloc] initWithRestaurantID:restaurantID tipAmount:tipAmount type:type];
}

- (instancetype)initWithRestaurantID:(NSString *)restaurantID tipAmount:(long long)tipAmount type:(NSString *)type {
  self = [super init];
  if (self) {
    _restaurant_id = restaurantID;
    _type = type;
    _tip = tipAmount;
  }
  return self;
}

- (NSString *)text {
  
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

@implementation OMNMailRuCard

- (instancetype)init {
  self = [super init];
  if (self) {
    self.pan = @"";
    self.exp_date = @"";
    self.cvv = @"";
    self.id = @"";
  }
  return self;
}

+ (NSString *)exp_dateFromMonth:(NSInteger)month year:(NSInteger)year {
  
  NSInteger shortYear = year%1000;
  return [NSString stringWithFormat:@"%02ld.20%02ld", (long)month, (long)shortYear];
  
}

+ (OMNMailRuCard *)cardWithID:(NSString *)card_id {
  
  OMNMailRuCard *cardInfo = [[OMNMailRuCard alloc] init];
  cardInfo.id = card_id;
  return cardInfo;
  
}

+ (OMNMailRuCard *)cardWithPan:(NSString *)pan exp_date:(NSString *)exp_date cvv:(NSString *)cvv {
  
  OMNMailRuCard *cardInfo = [[OMNMailRuCard alloc] init];
  cardInfo.pan = [[pan componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
  cardInfo.exp_date = exp_date;
  cardInfo.cvv = cvv;
  return cardInfo;
  
}

- (NSDictionary *)parameters {
  
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
  
  if (self.id.length) {
    
    parameters[@"card_id"] = self.id;
    
  }
  else {

    parameters[@"pan"] = self.pan;
    parameters[@"exp_date"] = (self.exp_date) ?: (@"");
    parameters[@"add_card"] = @(self.add_card);
    parameters[@"cvv"] = self.cvv;

  }

  return parameters;
  
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

@implementation OMNMailRuUser

- (instancetype)initWithLogin:(NSString *)login phone:(NSString *)phone {
  self = [super init];
  if (self) {
    _login = login;
    _phone = phone;
  }
  return self;
}

+ (instancetype)userWithLogin:(NSString *)login phone:(NSString *)phone {
  return [[OMNMailRuUser alloc] initWithLogin:login phone:phone];
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