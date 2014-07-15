//
//  OMNAnalitics.h
//  restaurants
//
//  Created by tea on 23.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

//https://trello.com/c/KirovnYP/32--
@interface OMNAnalitics : NSObject

+ (instancetype)analitics;

- (void)logRegisterUser:(OMNUser *)user;

- (void)logLoginUser:(OMNUser *)user;

- (void)logCardAdd:(OMNUser *)user;

- (void)logPayment:(OMNUser *)user;

@end
