//
//  OMNAnalitics.h
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class AFHTTPRequestOperation;
@class OMNOrder;
@class OMNAcquiringTransaction;
@class OMNUser;
@class OMNRestaurant;
@class OMNBankCardInfo;
@class OMNBill;

typedef NS_ENUM(NSInteger, RestaurantEnterMode) {
  kRestaurantEnterModeBackground = 0,
  kRestaurantEnterModeBackgroundTable,
  kRestaurantEnterModeApplicationLaunch,
};

//https://docs.google.com/document/d/1qCgjmjynrECxBm5tY934WzkvPo_3AoRpC0bpz-nfVc8/edit
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, strong) UIUserNotificationSettings *notificationSettings;

- (void)setUser:(OMNUser *)user;
- (void)setupWithToken:(NSString *)token debugToken:(NSString *)debugToken configuration:(NSString *)configuration base_url:(NSString *)base_url serverTimestamp:(NSTimeInterval)serverTimestamp;
- (BOOL)ready;
- (void)logUserLoginWithRegistration:(BOOL)withRegistration;
- (void)logEnterRestaurant:(OMNRestaurant *)restaurant mode:(RestaurantEnterMode)mode;
- (void)logPayment:(OMNAcquiringTransaction *)acquiringTransaction cardInfo:(OMNBankCardInfo *)bankCardInfo bill:(OMNBill *)bill;
- (void)logRegisterCards:(NSArray *)bankCards;
- (void)logScore:(NSInteger)score acquiringTransaction:(OMNAcquiringTransaction *)acquiringTransaction bill:(OMNBill *)bill;
- (void)logBillView:(OMNOrder *)order;

- (void)logTargetEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;

- (void)logMailEvent:(NSString *)eventName cardInfo:(OMNBankCardInfo *)bankCardInfo error:(NSError *)error ;
- (void)logDebugEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation;

@end
