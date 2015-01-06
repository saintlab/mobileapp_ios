//
//  OMNAnalitics.h
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class AFHTTPRequestOperation;
@class OMNOrder;
@class OMNOrderTansactionInfo;
@class OMNUser;
@class OMNRestaurant;

typedef NS_ENUM(NSInteger, RestaurantEnterMode) {
  kRestaurantEnterModeBackground = 0,
  kRestaurantEnterModeBackgroundTable,
  kRestaurantEnterModeApplicationLaunch,
};

//https://docs.google.com/document/d/1qCgjmjynrECxBm5tY934WzkvPo_3AoRpC0bpz-nfVc8/edit
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

@property (nonatomic, strong) NSData *deviceToken;

- (void)setUser:(OMNUser *)user;
- (void)setServerTimeStamp:(NSTimeInterval)serverTimeStamp;
- (void)setup;
- (void)logUserLoginWithRegistration:(BOOL)withRegistration;
- (void)logEnterRestaurant:(OMNRestaurant *)restaurant mode:(RestaurantEnterMode)mode;
- (void)logPayment:(OMNOrderTansactionInfo *)orderTansactionInfo bill_id:(NSString *)bill_id;
- (void)logScore:(NSInteger)score order:(OMNOrder *)order;
- (void)logBillView:(OMNOrder *)order;

- (void)logTargetEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;

- (void)logMailEvent:(NSString *)eventName error:(NSError *)error request:(NSDictionary *)request response:(NSDictionary *)response;
- (void)logDebugEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation;

@end
