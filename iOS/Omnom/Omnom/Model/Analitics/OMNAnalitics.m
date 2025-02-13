//
//  OMNAnalitics.m
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNOrder.h"
#import "OMNUser.h"
#import "OMNUser+network.h"
#import "OMNRestaurant.h"
#import <AFNetworking.h>
#import <Mixpanel.h>
#import "OMNAuthorization.h"
#import "OMNBankCardInfo.h"
#import "OMNBankCard.h"
#import "OMNAcquiringTransaction.h"

NSString * const OMNAnaliticsUserKey = @"omn_user";

@interface OMNAnalitics ()

@property (nonatomic, strong, readonly) OMNUser *user;

@end

@implementation OMNAnalitics {
  
  Mixpanel *_mixpanel;
  Mixpanel *_mixpanelDebug;
  NSTimeInterval _serverTimeDelta;
  
}

+ (instancetype)analitics {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (void)setupWithToken:(NSString *)token debugToken:(NSString *)debugToken configuration:(NSString *)configuration base_url:(NSString *)base_url serverTimestamp:(NSTimeInterval)serverTimestamp {
  
  [self setServerTimeStamp:serverTimestamp];
  
  [_mixpanel flush], _mixpanel = nil;
  if (token) {
    _mixpanel = [[Mixpanel alloc] initWithToken:token andFlushInterval:60];
    _mixpanel.flushInterval = 60;
  }

  [_mixpanelDebug flush], _mixpanelDebug = nil;
  
  if (debugToken) {
    
    _mixpanelDebug = [[Mixpanel alloc] initWithToken:debugToken andFlushInterval:60];
    _mixpanelDebug.flushInterval = 60;
    
  }
  
  NSDictionary *properties =
  @{
    @"mobile_configuration" : configuration,
    @"base_url" : base_url,
    };
  [_mixpanel registerSuperProperties:properties];
  [_mixpanelDebug registerSuperProperties:properties];
  
  [self updateUserInfo];
  
}

- (BOOL)ready {
  return (_mixpanel != nil);
}

- (void)setServerTimeStamp:(NSTimeInterval)serverTimeStamp {
  
  NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
  _serverTimeDelta = (currentTime - serverTimeStamp);
  
}

- (void)updateUserInfo {
  
  if (!_user) {
    [_mixpanel.people deleteUser];
    [_mixpanel unregisterSuperProperty:OMNAnaliticsUserKey];
    
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
  
  [_mixpanel.people set:@"push_notification_requested" to:@([OMNAuthorization authorization].pushNotificationsRequested)];
  [_mixpanel.people set:userInfo];
  [self updateUserDeviceTokenIfNeeded];
  [_mixpanelDebug.people set:userInfo];

  [_mixpanel registerSuperProperties:@{OMNAnaliticsUserKey : userInfo}];
  [_mixpanelDebug registerSuperProperties:@{OMNAnaliticsUserKey : userInfo}];
  
  [_mixpanel flush];
  [_mixpanelDebug flush];
  
}

- (void)setUser:(OMNUser *)user {
  
  _user = user;
  [self updateUserInfo];
  
}

- (void)logEnterRestaurant:(OMNRestaurant *)restaurant mode:(RestaurantEnterMode)mode {
  
  NSMutableDictionary *properties = [self superProperties];
  if (restaurant.title) {
    properties[@"restaurant_name"] = restaurant.title;
  }
  if (restaurant.id) {
    properties[@"restaurant_id"] = restaurant.id;
  }
  
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

- (void)logScore:(NSInteger)score acquiringTransaction:(OMNAcquiringTransaction *)acquiringTransaction bill:(OMNBill *)bill {

  NSMutableDictionary *properties = [self superProperties];
  properties[@"score"] = @(score);
  properties[@"order_id"] = (acquiringTransaction.order_id) ?: (@"");
  properties[@"bill_id"] = (bill.id) ?: (@"");
  [_mixpanel track:@"user_score" properties:properties];

}

- (void)logBillView:(OMNOrder *)order {
  
  NSMutableDictionary *properties = [self superProperties];
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
}

- (void)logPayment:(OMNAcquiringTransaction *)acquiringTransaction cardInfo:(OMNBankCardInfo *)bankCardInfo bill:(OMNBill *)bill {
  
  [_mixpanel.people increment:
   @{
     @"bill_sum" : @(acquiringTransaction.bill_amount),
     @"tips_sum" : @(acquiringTransaction.tips_amount),
     @"total_sum" : @(acquiringTransaction.total_amount),
     @"number_of_payments" : @(1),
     }];
  [_mixpanel.people set:@"last_payment" to:[NSDate date]];
  [_mixpanel.people trackCharge:@(bill.revenue) withProperties:
  @{
    @"order_id" : acquiringTransaction.order_id,
    @"bill_id" : (bill.id) ?: (@""),
    }];
  
  NSMutableDictionary *properties = [self superProperties];
  [properties addEntriesFromDictionary:
   @{
     @"bill_sum" : @(acquiringTransaction.bill_amount),
     @"tips_sum" : @(acquiringTransaction.tips_amount),
     @"total_amount" : @(acquiringTransaction.total_amount),
     @"percent" : @(acquiringTransaction.tips_percent),
     @"tips_way" : acquiringTransaction.tips_way,
     @"split" : acquiringTransaction.split_way,
     @"order_id" : (acquiringTransaction.order_id) ?: (@""),
     @"wish_id" : (acquiringTransaction.wish_id) ?: (@""),
     @"restaurant_id" : (acquiringTransaction.restaurant_id) ?: (@""),
     @"table_id" : (acquiringTransaction.table_id) ?: (@""),
     @"bill_id" : (bill.id) ?: (@""),
     @"card_info" : (bankCardInfo) ? (bankCardInfo.debugInfo) : (@""),
     @"transaction_info" : (acquiringTransaction.info) ?: @"",
     }];
  [_mixpanel track:@"payment_success" properties:properties];
  [_mixpanel flush];
  
}

- (void)logRegisterCards:(NSArray *)bankCards {
  
  __block NSInteger heldCardsCount = 0;
  __block NSInteger registerCardsCount = 0;
  NSArray *enumerateCards = [bankCards copy];
  [enumerateCards enumerateObjectsUsingBlock:^(OMNBankCard *bankCard, NSUInteger idx, BOOL *stop) {
    
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

  NSMutableDictionary *newParamentrs = [self superProperties];
  [newParamentrs addEntriesFromDictionary:parametrs];
  [_mixpanel track:eventName properties:newParamentrs];
  
}

- (void)logMailEvent:(NSString *)eventName cardInfo:(OMNBankCardInfo *)bankCardInfo error:(NSError *)error {
  
  NSMutableDictionary *debugInfo = [self superProperties];
  debugInfo[@"error"] = (error.userInfo) ?: (@"");
  debugInfo[@"errorCode"] = @(error.code);
  if (bankCardInfo) {
    debugInfo[@"card_info"] = bankCardInfo.debugInfo;
  }
  [_mixpanel track:eventName properties:debugInfo];

}

- (void)logDebugEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs {
  
  NSMutableDictionary *newParamentrs = [self superProperties];
  [newParamentrs addEntriesFromDictionary:parametrs];
  [_mixpanelDebug track:eventName properties:newParamentrs];
  
}

- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse {
  
  NSMutableDictionary *parametrs = [self superProperties];
  parametrs[@"jsonRequest"] = (jsonRequest) ? (jsonRequest) : (@"");
  parametrs[@"jsonResponse"] = (jsonResponse) ? (jsonResponse) : (@"");
  [_mixpanelDebug track:eventName properties:parametrs];
  
}

- (NSMutableDictionary *)superProperties {
  
  static NSDateFormatter *dateFormatter = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"ru"]];
    [dateFormatter setDateFormat:@"{yyyy-MM-dd'T'HH:mm:ssZZZZZ}"];
  });
  
  NSDate *actualDate = [NSDate dateWithTimeIntervalSinceNow:-_serverTimeDelta];
  
  NSMutableDictionary *timeProperties =
  [@{
    @"timestamp" : [dateFormatter stringFromDate:actualDate],
    @"time" : @([actualDate timeIntervalSince1970]),
    } mutableCopy];
  
  return timeProperties;
  
}

- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation {

  NSString *requestID = responseOperation.response.allHeaderFields[@"X-Request-ID"];
  NSMutableDictionary *properties = [self superProperties];
  [properties addEntriesFromDictionary:
   @{
     @"jsonRequest" : (jsonRequest) ?: (@""),
     @"error" : (responseOperation.error.userInfo) ?: (@""),
     @"errorCode" : @(responseOperation.error.code),
     @"statusCode" : @(responseOperation.response.statusCode),
     @"requestID" : (requestID) ?: (@"unknown"),
     @"responseString" : (responseOperation.responseString) ?: (@""),
     @"request_headers" : responseOperation.request.allHTTPHeaderFields,
     }];
  
  [_mixpanelDebug track:eventName properties:properties];
  
}

- (void)setDeviceToken:(NSData *)deviceToken {
  
  _deviceToken = deviceToken;
  [self updateUserDeviceTokenIfNeeded];
  
}

- (void)setNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
  
  _notificationSettings = notificationSettings;
  [self updateUserDeviceTokenIfNeeded];
  
}

- (BOOL)userNotificationPermissionReceived {
  
  if (![UIUserNotificationSettings class]) {
    return YES;
  }
  
  BOOL userNotificationPermissionReceived = (_notificationSettings.types != UIUserNotificationTypeNone);
  return userNotificationPermissionReceived;
  
}

- (void)updateUserDeviceTokenIfNeeded {
  
  if (!_user) {
    return;
  }
  
  if (_deviceToken) {
   
    [_mixpanel.people addPushDeviceToken:_deviceToken];

  }
  
  BOOL userCanReceivePush = (_deviceToken != nil &&
                             [self userNotificationPermissionReceived]);
  [_mixpanel.people set:@"user_can_receive_push" to:@(userCanReceivePush)];
  
}

@end
