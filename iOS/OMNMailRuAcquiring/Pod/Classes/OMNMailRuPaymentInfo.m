//
//  OMNMailRuPaymentInfo.m
//  Pods
//
//  Created by tea on 11.08.14.
//
//

#import "OMNMailRuPaymentInfo.h"
#import "OMNMailRuAcquiring.h"

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
    self.type = @"";
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
  cardInfo.cvv = [[OMNMailRuAcquiring acquiring] testCVV];
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
    card_info[@"add_card"] = @(0);
  }
  
  if (self.cvv.length) {
    card_info[@"cvv"] = self.cvv;
  }
  
  return card_info;
}

@end