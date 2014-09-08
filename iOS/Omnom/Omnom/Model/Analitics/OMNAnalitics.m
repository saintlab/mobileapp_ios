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
    userInfo[@"ID"] = user.id;
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
  if (user.created_at) {
    userInfo[@"created"] = user.created_at;
  }
  [_mixpanel.people set:userInfo];
  [_mixpanel registerSuperProperties:@{@"omn_user" : userInfo}];
}

- (void)logEnterRestaurant:(OMNVisitor *)visitor {
  
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  if (visitor.restaurant.title) {
    properties[@"restaurant_name"] = visitor.restaurant.title;
  }
  if (visitor.beacon) {
    properties[@"method_used"] = @"Bluetooth";
    properties[@"id"] = [visitor.beacon key];
  }
  else {
    properties[@"method_used"] = @"QR";
  }
  [_mixpanel track:@"restaurant_enter" properties:properties];
  [_mixpanel.people set:@"last_visited" to:[NSDate date]];
  [_mixpanel.people increment:@"total_visits" by:@(1)];
  
}

- (void)logRegister {
  
  [_mixpanel track:@"user_registered" properties:nil];
  
}

- (void)logLogin {
  
  [_mixpanel track:@"USER_DID_LOGIN" properties:nil];
  
}

-(void)logPayment:(OMNOrder *)order {
  
  [_mixpanel.people increment:
   @{
     @"bill_sum" : @(order.enteredAmount),
     @"tips_sum" : @(order.tipAmount),
     @"total_sum" : @(order.enteredAmountWithTips),
     @"number_of_payments" : @(1),
     }];
  
  double percent = 0.0f;
  if (order.enteredAmount) {
    percent = (double)order.tipAmount/order.enteredAmount;
  }
  
  [_mixpanel track:@"payment_success" properties:
   @{
     @"bill_sum" : @(order.enteredAmount),
     @"tips_sum" : @(order.tipAmount),
     @"total_amount" : @(order.enteredAmountWithTips),
     @"percent" : @(percent),
     @"tips_way" : stringFromTipType(order.tipType),
     @"split" : stringFromSplitType(order.splitType),
     }];
  
}

- (void)logEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {
  
  [_mixpanel track:eventName properties:parametrs];
  
}

- (void)logEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse {
  
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"jsonRequest"] = (jsonRequest) ? (jsonRequest) : (@"");
  parametrs[@"jsonResponse"] = (jsonResponse) ? (jsonResponse) : (@"");
  [_mixpanel track:eventName properties:parametrs];
  
}

- (void)logEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation {
  
  [_mixpanel track:eventName properties:
  @{
    @"jsonRequest" : (jsonRequest) ? (jsonRequest) : (@""),
    @"error" : (responseOperation.error.localizedDescription) ? (responseOperation.error.localizedDescription) : (@""),
    @"responseString" : (responseOperation.responseString) ? (responseOperation.responseString) : (@""),
    }];
  
}

@end
