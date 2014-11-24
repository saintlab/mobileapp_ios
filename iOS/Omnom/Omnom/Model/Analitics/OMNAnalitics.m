//
//  OMNAnalitics.m
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNConstants.h"
#import "OMNOrder.h"
#import "OMNOrderTansactionInfo.h"
#import "OMNUser.h"
#import "OMNVisitor.h"
#import <AFNetworking.h>
#import <Mixpanel.h>

@interface OMNAnalitics ()

@end

@implementation OMNAnalitics {
  Mixpanel *_mixpanel;
  Mixpanel *_mixpanelDebug;
  
  OMNUser *_user;
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
    
  }
  return self;
}

- (void)setUser:(OMNUser *)user {
  
  _user = user;
  
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
  [self updateUserDeviceTokenIfNeeded];
  [_mixpanel flush];
  
  [_mixpanelDebug.people set:userInfo];
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

  if (visitor.table.id) {
    properties[@"table_id"] = visitor.table.id;
  }
  
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

- (void)logPayment:(OMNOrderTansactionInfo *)orderTansactionInfo bill_id:(NSString *)bill_id {
  
  [_mixpanel.people increment:
   @{
     @"bill_sum" : @(orderTansactionInfo.bill_amount),
     @"tips_sum" : @(orderTansactionInfo.tips_amount),
     @"total_sum" : @(orderTansactionInfo.total_amount),
     @"number_of_payments" : @(1),
     }];
  [_mixpanel.people set:@"last_payment" to:[NSDate date]];
  
  [_mixpanel track:@"payment_success" properties:
   @{
     @"bill_sum" : @(orderTansactionInfo.bill_amount),
     @"tips_sum" : @(orderTansactionInfo.tips_amount),
     @"total_amount" : @(orderTansactionInfo.total_amount),
     @"percent" : @(orderTansactionInfo.tips_percent),
     @"tips_way" : orderTansactionInfo.tips_way,
     @"split" : orderTansactionInfo.split,
     @"timestamp" : [self dateString],
     @"order_id" : orderTansactionInfo.order_id,
     @"restaurant_id" : orderTansactionInfo.restaurant_id,
     @"table_id" : orderTansactionInfo.table_id,
     @"bill_id" : (bill_id) ? (bill_id) : (@""),
     }];
  [_mixpanel flush];
  
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
    [dateFormatter setDateFormat:@"{yyyy-MM-dd'T'HH:mm:ssZZZZZ}"];
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

- (void)setDeviceToken:(NSData *)deviceToken {
  
  _deviceToken = deviceToken;
  [self updateUserDeviceTokenIfNeeded];
  
}

- (void)updateUserDeviceTokenIfNeeded {
  
  if (_user &&
      _deviceToken) {
    
    [_mixpanel.people addPushDeviceToken:_deviceToken];
    
  }
  
}

@end
