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

//https://trello.com/c/KirovnYP/32--
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

- (void)setUser:(OMNUser *)user;

- (void)logRegister;
- (void)logLogin;
- (void)logEnterRestaurant:(OMNVisitor *)visitor;
- (void)logPayment:(OMNOrder *)order;

- (void)logEvent:(NSString *)eventName parametrs:(NSDictionary *)parametrs;
- (void)logEvent:(NSString *)eventName operation:(AFHTTPRequestOperation *)operation;

@end
