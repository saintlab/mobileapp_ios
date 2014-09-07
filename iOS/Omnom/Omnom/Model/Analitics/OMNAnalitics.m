//
//  OMNAnalitics.m
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import <Mixpanel.h>
#import "OMNConstants.h"
#import <AFNetworking.h>
#import "OMNVisitor.h"
#import "OMNUser.h"
#import "OMNOrder.h"

@interface OMNAnalitics ()

@end

@implementation OMNAnalitics {
  Mixpanel *_mixpanel;
}

+ (instancetype)analitics {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _mixpanel = [[Mixpanel alloc] initWithToken:[OMNConstants mixpanelToken] launchOptions:nil andFlushInterval:60.0];
    _mixpanel.flushInterval = 60.0;
  }
  return self;
}

- (void)setUser:(OMNUser *)user {
  
  if (nil == user) {
    [_mixpanel flush];
    [_mixpanel.people deleteUser];
    [_mixpanel unregisterSuperProperty:@"omn_user"];
    return;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  if (user.name) {
    userInfo[@"name"] = user.name;
  }
  if (user.id) {
    [_mixpanel identify:user.id];
    userInfo[@"id"] = user.id;
  }
  if (user.email) {
    userInfo[@"email"] = user.email;
  }
  if (user.phone) {
    userInfo[@"phone"] = user.phone;
  }
  if (user.birthDate) {
    userInfo[@"phone"] = user.birthDate;
  }
  
  [_mixpanel.people set:userInfo];
  [_mixpanel registerSuperProperties:@{@"omn_user" : userInfo}];
}

- (void)logEnterRestaurant:(OMNVisitor *)visitor {
  
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  if (visitor.restaurant.title) {
    properties[@"name"] = visitor.restaurant.title;
  }
  if (visitor.beacon) {
    properties[@"source"] = @"beacon";
    properties[@"id"] = [visitor.beacon key];
  }
  
  [_mixpanel track:@"USER_DID_ENTER_RESTAURANT" properties:properties];
  
}

- (void)logRegister {
  
  [_mixpanel track:@"USER_DID_REGISTER" properties:nil];
  
}

- (void)logLogin {
  
  [_mixpanel track:@"USER_DID_LOGIN" properties:nil];
  
}

-(void)logPayment:(OMNOrder *)order {
  
  [_mixpanel.people increment:
   @{
     @"sum_amount" : @(order.enteredAmount),
     @"sum_tip_amount" : @(order.tipAmount),
     @"sum_total_amount" : @(order.enteredAmountWithTips),
     @"number_of_payments" : @(1),
     }];
  
  double percent = 0.0f;
  if (order.enteredAmount) {
    percent = (double)order.tipAmount/order.enteredAmount;
  }
  
  [_mixpanel track:@"USER_DID_PAY" properties:
   @{
     @"amount" : @(order.enteredAmount),
     @"tip_amount" : @(order.tipAmount),
     @"total_amount" : @(order.enteredAmountWithTips),
     @"percent" : @(percent),
     @"tip_type" : stringFromTipType(order.tipType),
     @"split_type" : stringFromSplitType(order.splitType),
     }];
  
}

- (void)logEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {
  
  [_mixpanel track:eventName properties:parametrs];
  
}

- (void)logEvent:(NSString *)eventName operation:(AFHTTPRequestOperation *)operation {
  
  NSString *response = (operation.responseString) ? (operation.responseString) : (operation.error.localizedDescription);
  response = (response.length) ? (response) : @"";
  [_mixpanel track:eventName properties:@{@"response" : response}];
  
}

@end
