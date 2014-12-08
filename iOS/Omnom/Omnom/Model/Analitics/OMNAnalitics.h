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
@class OMNVisitor;

#import <CoreLocation/CoreLocation.h>

//https://docs.google.com/document/d/1qCgjmjynrECxBm5tY934WzkvPo_3AoRpC0bpz-nfVc8/edit
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

@property (nonatomic, strong) NSData *deviceToken;

- (void)setUser:(OMNUser *)user;

- (void)logUserLocation:(CLLocationCoordinate2D)coordinate;
- (void)logRegister;
- (void)logLogin;
- (void)logEnterRestaurant:(OMNVisitor *)visitor foreground:(BOOL)foreground;
- (void)logPayment:(OMNOrderTansactionInfo *)orderTansactionInfo bill_id:(NSString *)bill_id;
- (void)logScore:(NSInteger)score order:(OMNOrder *)order;
- (void)logBillView:(OMNOrder *)order;

- (void)logTargetEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;

- (void)logDebugEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse;
- (void)logDebugEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation;

@end
