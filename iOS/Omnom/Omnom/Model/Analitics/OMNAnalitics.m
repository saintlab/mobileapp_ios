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
  Mixpanel *_mixpanelDebug;
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
    
    NSString *mixpanelDebugToken = [OMNConstants mixpanelDebugToken];
    if (mixpanelDebugToken.length) {
      _mixpanelDebug = [[Mixpanel alloc] initWithToken:mixpanelDebugToken andFlushInterval:60.0];
      _mixpanelDebug.flushInterval = 60.0;
    }
//    cbf84d3a959d264d62c06a48d03b1a28
    
  }
  return self;
}

- (void)setUser:(OMNUser *)user {
  
  if (nil == user) {
    [_mixpanel flush];
    [_mixpanel.people deleteUser];
    [_mixpanel unregisterSuperProperty:@"omn_user"];
    
    [_mixpanelDebug flush];
    [_mixpanelDebug.people deleteUser];
    [_mixpanelDebug unregisterSuperProperty:@"omn_user"];
    return;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  if (user.id) {
    // mixpanel identify: must be called before
    // people properties can be set
    [_mixpanel identify:user.id];
    [_mixpanelDebug identify:user.id];
    userInfo[@"ID"] = user.id;
    
  }
  if (user.name) {
    userInfo[@"name"] = user.name;
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
  [_mixpanel flush];
  
  [_mixpanelDebug registerSuperProperties:@{@"omn_user" : userInfo}];
  [_mixpanelDebug flush];
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
  properties[@"timestamp"] = [self dateString];
  [_mixpanel track:@"restaurant_enter" properties:properties];
  [_mixpanel.people set:@"last_visited" to:[NSDate date]];
  [_mixpanel.people increment:@"total_visits" by:@(1)];
  
}

- (void)logScore:(CGFloat)score order:(OMNOrder *)order {

  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  properties[@"timestamp"] = [self dateString];
  properties[@"score"] = @(score);
  properties[@"order_id"] = (order.id) ? (order.id) : (@"");
  properties[@"bill_id"] = (order.bill.id) ? (order.bill.id) : (@"");
  [_mixpanel track:@"user_score" properties:properties];

}

- (void)logRegister {
  
  [_mixpanel track:@"user_registered" properties:nil];
  
}

- (void)logLogin {
  
  [_mixpanel track:@"user_login" properties:nil];
  
}

-(void)logPayment:(OMNOrder *)order {
  
  [_mixpanel.people increment:
   @{
     @"bill_sum" : @(order.enteredAmount),
     @"tips_sum" : @(order.tipAmount),
     @"total_sum" : @(order.enteredAmountWithTips),
     @"number_of_payments" : @(1),
     }];
  [_mixpanel.people set:@"last_payment" to:[NSDate date]];
  
  double percent = 0.0f;
  if (order.enteredAmount) {
    percent = (double)order.tipAmount/order.enteredAmount;
  }
  
//  (0.7% счёта + 50% чая)
  double charge = 0.007l*order.enteredAmount + 0.5l*order.tipAmount;
  [_mixpanel.people trackCharge:@(charge)];

  
  [_mixpanel track:@"payment_success" properties:
   @{
     @"bill_sum" : @(order.enteredAmount),
     @"tips_sum" : @(order.tipAmount),
     @"total_amount" : @(order.enteredAmountWithTips),
     @"percent" : @(percent),
     @"tips_way" : stringFromTipType(order.tipType),
     @"split" : stringFromSplitType(order.splitType),
     @"timestamp" : [self dateString],
     }];

}

- (void)logTargetEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {
  
  NSMutableDictionary *newParamentrs = [NSMutableDictionary dictionaryWithDictionary:parametrs];
  newParamentrs[@"timestamp"] = [self dateString];
  [_mixpanel track:eventName properties:newParamentrs];
  
}

- (void)logDebugEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {
  
  NSMutableDictionary *newParamentrs = [NSMutableDictionary dictionaryWithDictionary:parametrs];
  newParamentrs[@"timestamp"] = [self dateString];
  [_mixpanelDebug track:eventName properties:newParamentrs];
  
}

- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse {
  
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"jsonRequest"] = (jsonRequest) ? (jsonRequest) : (@"");
  parametrs[@"jsonResponse"] = (jsonResponse) ? (jsonResponse) : (@"");
  parametrs[@"timestamp"] = [self dateString];
  [_mixpanelDebug track:eventName properties:parametrs];
  
}

- (NSString *)dateString {
  
  static NSDateFormatter *dateFormatter = nil;
  if (nil == dateFormatter) {
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
  }
  return [dateFormatter stringFromDate:[NSDate date]];
  
}

- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation {
  
  [_mixpanelDebug track:eventName properties:
  @{
    @"timestamp" : [self dateString],
    @"jsonRequest" : (jsonRequest) ? (jsonRequest) : (@""),
    @"error" : (responseOperation.error.localizedDescription) ? (responseOperation.error.localizedDescription) : (@""),
    @"errorCode" : @(responseOperation.error.code),
    @"responseString" : (responseOperation.responseString) ? (responseOperation.responseString) : (@""),
    }];
  
}

@end
