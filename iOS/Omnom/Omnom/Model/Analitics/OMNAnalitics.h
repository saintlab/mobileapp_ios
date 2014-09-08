//
//  OMNAnalitics.h
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNUser;
@class AFHTTPRequestOperation;
@class OMNVisitor;
@class OMNOrder;

//https://docs.google.com/document/d/1qCgjmjynrECxBm5tY934WzkvPo_3AoRpC0bpz-nfVc8/edit
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

- (void)setUser:(OMNUser *)user;

- (void)logRegister;
- (void)logLogin;
- (void)logEnterRestaurant:(OMNVisitor *)visitor;
- (void)logPayment:(OMNOrder *)order;

- (void)logEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;
- (void)logEvent:(NSString *)eventName jsonRequest:(id)jsonRequest jsonResponse:(NSDictionary *)jsonResponse;
- (void)logEvent:(NSString *)eventName jsonRequest:(id)jsonRequest responseOperation:(AFHTTPRequestOperation *)responseOperation;

@end
