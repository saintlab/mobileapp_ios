//
//  OMNAnalitics.m
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNOrder.h"
#import "OMNOrderTansactionInfo.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "OMNRestaurant.h"
#import <AFNetworking.h>
#import <Mixpanel.h>
#import "OMNAuthorization.h"
#import "OMNLocationManager.h"
#import "OMNBankCardInfo.h"
#import "OMNBankCard.h"

NSString * const OMNAnaliticsUserKey = @"omn_user";

@interface OMNAnalitics ()

@end

@implementation OMNAnalitics {
  
  Mixpanel *_mixpanel;
  Mixpanel *_mixpanelDebug;
  NSTimeInterval _serverTimeDelta;
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
  }
  return self;
}

- (void)setup {
  
  [_mixpanel flush];
  _mixpanel = [[Mixpanel alloc] initWithToken:[OMNConstants mixpanelToken] andFlushInterval:60.0];
  _mixpanel.flushInterval = 60.0;

  [_mixpanelDebug flush];
  _mixpanelDebug = nil;
  
  NSString *mixpanelDebugToken = [OMNConstants mixpanelDebugToken];
  if (mixpanelDebugToken.length) {
    
    _mixpanelDebug = [[Mixpanel alloc] initWithToken:mixpanelDebugToken andFlushInterval:60.0];
    _mixpanelDebug.flushInterval = 60.0;
    
  }
  [self updateUserInfo];
  
}

- (void)setServerTimeStamp:(NSTimeInterval)serverTimeStamp {
  
  NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
  _serverTimeDelta = (currentTime - serverTimeStamp);
  
}

- (void)updateUserInfo {
  
  if (nil == _user) {
    [_mixpanel flush];
    [_mixpanel.people deleteUser];
    [_mixpanel unregisterSuperProperty:OMNAnaliticsUserKey];
    
    [_mixpanelDebug flush];
    [_mixpanelDebug.people deleteUser];
    [_mixpanelDebug unregisterSuperProperty:OMNAnaliticsUserKey];
    return;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  if (_user.id) {
    // mixpanel identify: must be called before
    // people properties can be set
    [_mixpanel identify:_user.id];
    [_mixpanelDebug identify:_user.id];
    userInfo[@"ID"] = _user.id;
  }
  
  userInfo[@"push_activated"] = @([OMNAuthorization authorisation].pushNotificationsRequested);
  
  if (_user.name) {
    userInfo[@"name"] = _user.name;
  }
  if (_user.email) {
    userInfo[@"$email"] = _user.email;
  }
  if (_user.phone) {
    userInfo[@"phone"] = _user.phone;
  }
  if (_user.birthDateString.length) {
    userInfo[@"birth_date"] = _user.birthDateString;
  }
  if (_user.created_at) {
    userInfo[@"created"] = _user.created_at;
  }
  [_mixpanel.people set:userInfo];
  [_mixpanel registerSuperProperties:@{OMNAnaliticsUserKey : userInfo}];
  [self updateUserDeviceTokenIfNeeded];
  [_mixpanel flush];
  
  [_mixpanelDebug.people set:userInfo];
  [_mixpanelDebug registerSuperProperties:@{OMNAnaliticsUserKey : userInfo}];
  [_mixpanelDebug flush];
  
}

- (void)setUser:(OMNUser *)user {
  
  _user = user;
  [self updateUserInfo];
  
}

- (void)logEnterRestaurant:(OMNRestaurant *)restaurant mode:(RestaurantEnterMode)mode {
  
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  if (restaurant.title) {
    properties[@"restaurant_name"] = restaurant.title;
  }
  if (restaurant.id) {
    properties[@"restaurant_id"] = restaurant.id;
  }
#warning logEnterRestaurant
//  if (visitor.beacon) {
//    properties[@"method_used"] = @"Bluetooth";
//    properties[@"id"] = [visitor.beacon key];
//  }
//  else {
//    properties[@"method_used"] = @"QR";
//  }
  properties[@"timestamp"] = [self dateString];

  if (1 == restaurant.tables.count) {
    OMNTable *table = restaurant.tables[0];
    properties[@"table_id"] = table.id;
  }
  
  NSString *eventName = @"";
  switch (mode) {
    case kRestaurantEnterModeBackground: {
      eventName = @"restaurant_enter";
    } break;
    case kRestaurantEnterModeBackgroundTable: {
      eventName = @"on_table";
    } break;
    case kRestaurantEnterModeApplicationLaunch: {
      eventName = @"application_launch";
    } break;
  }
  
  [_mixpanel track:eventName properties:properties];
  [_mixpanel.people set:@"last_visited" to:[NSDate date]];
  [_mixpanel flush];
  
}

- (void)logScore:(NSInteger)score order:(OMNOrder *)order {

  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  properties[@"timestamp"] = [self dateString];
  properties[@"score"] = @(score);
  properties[@"order_id"] = (order.id) ? (order.id) : (@"");
  properties[@"bill_id"] = (order.bill.id) ? (order.bill.id) : (@"");
  [_mixpanel track:@"user_score" properties:properties];

}

- (void)logBillView:(OMNOrder *)order {
  
  NSMutableDictionary *properties = [NSMutableDictionary dictionary];
  properties[@"timestamp"] = [self dateString];
  properties[@"restaurant_id"] = (order.restaurant_id) ? (order.restaurant_id) : (@"");
  properties[@"table_id"] = (order.table_id) ? (order.table_id) : (@"");
  properties[@"order_id"] = (order.id) ? (order.id) : (@"");
  properties[@"amount"] = @(order.totalAmount);
  properties[@"paid_amount"] = @(order.paid.total_amount);
  properties[@"paid_tip_amount"] = @(order.paid.tip_amount);
  [_mixpanel track:@"bill_view" properties:properties];
  
}

- (void)logUserLoginWithRegistration:(BOOL)withRegistration {
  
  [_mixpanel track:(withRegistration) ? (@"user_registered") : (@"user_login") properties:nil];

  [[OMNLocationManager sharedManager] getLocation:^(CLLocationCoordinate2D coordinate) {
    
    [_user logCoordinates:coordinate];
    
  }];
  
}

- (void)logPayment:(OMNOrderTansactionInfo *)orderTansactionInfo cardInfo:(OMNBankCardInfo *)bankCardInfo bill_id:(NSString *)bill_id {
  
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
     @"card_info" : (bankCardInfo) ? (bankCardInfo.debugInfo) : (@""),
     }];
  [_mixpanel flush];
  
}

- (void)logRegisterCards:(NSArray *)bankCards {
  
  __block NSInteger heldCardsCount = 0;
  __block NSInteger registerCardsCount = 0;
  [bankCards enumerateObjectsUsingBlock:^(OMNBankCard *bankCard, NSUInteger idx, BOOL *stop) {
    
    switch (bankCard.status) {
      case kOMNBankCardStatusUnknown: {
        
      } break;
      case kOMNBankCardStatusHeld: {
        heldCardsCount++;
      } break;
      case kOMNBankCardStatusRegistered: {
        registerCardsCount++;
      } break;
    }
    
  }];
  
  [_mixpanel.people set:@"held_cards_count" to:@(heldCardsCount)];
  [_mixpanel.people set:@"register_cards_count" to:@(registerCardsCount)];
  
}

- (void)logTargetEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {

  NSMutableDictionary *newParamentrs = [NSMutableDictionary dictionaryWithDictionary:parametrs];
  newParamentrs[@"timestamp"] = [self dateString];
  [_mixpanel track:eventName properties:newParamentrs];
  
}

- (void)logMailEvent:(NSString *)eventName cardInfo:(OMNBankCardInfo *)bankCardInfo  error:(NSError *)error request:(NSDictionary *)request response:(NSDictionary *)response {
  
  NSMutableDictionary *debugInfo = [NSMutableDictionary dictionary];
  if (error.localizedDescription) {
    debugInfo[@"error"] = error.localizedDescription;
  }
  debugInfo[@"errorCode"] = @(error.code);
  
  if (request) {
    debugInfo[@"request"] = request;
  }
  
  if (response) {
    debugInfo[@"response"] = response;
  }
  
  if (bankCardInfo) {
    debugInfo[@"card_info"] = bankCardInfo.debugInfo;
  }

  debugInfo[@"timestamp"] = [self dateString];
  [_mixpanel track:eventName properties:debugInfo];

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
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
    [dateFormatter setDateFormat:@"{yyyy-MM-dd'T'HH:mm:ssZZZZZ}"];
  }
  
  NSDate *actualDate = [NSDate dateWithTimeIntervalSinceNow:-_serverTimeDelta];
  return [dateFormatter stringFromDate:actualDate];
  
}

- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation {

  NSString *requestID = responseOperation.response.allHeaderFields[@"X-Request-ID"];
  
  [_mixpanelDebug track:eventName properties:
  @{
    @"timestamp" : [self dateString],
    @"jsonRequest" : (jsonRequest) ? (jsonRequest) : (@""),
    @"error" : (responseOperation.error.localizedDescription) ? (responseOperation.error.localizedDescription) : (@""),
    @"errorCode" : @(responseOperation.error.code),
    @"requestID" : (requestID) ? (requestID) : (@"unknown"),
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
