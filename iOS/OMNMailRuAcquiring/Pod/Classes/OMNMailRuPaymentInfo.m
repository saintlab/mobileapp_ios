//
//  OMNMailRuPaymentInfo.m
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import "OMNMailRuPaymentInfo.h"

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

@end

@implementation OMNMailRuExtra

- (instancetype)init {
  self = [super init];
  if (self) {
    self.restaurant_id = @"";
  }
  return self;
}

- (NSString *)extra_text {
  
  if (0 == self.restaurant_id.length) {
    return nil;
  }
  
  NSDictionary *extra =
  @{
    @"tip" : @(self.tip),
    @"restaurant_id" : self.restaurant_id,
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

- (NSDictionary *)card_info {
  
  NSMutableDictionary *card_info = [NSMutableDictionary dictionary];
  
  if (self.card_id.length) {
    card_info[@"card_id"] = self.card_id;
  }
  else {
    card_info[@"pan"] = self.pan;
    card_info[@"exp_date"] = self.exp_date;
  }
  
  if (self.cvv.length) {
    card_info[@"cvv"] = self.cvv;
  }
  
  return card_info;
}

@end