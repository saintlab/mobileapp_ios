//
//  OMNOrderPaid.h
//  omnom
//
//  Created by tea on 22.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNOrderPaid : NSObject

@property (nonatomic, assign) long long total_amount;
@property (nonatomic, assign) long long tip_amount;
@property (nonatomic, assign, readonly) long long net_amount;

- (instancetype)initWithTotal:(long long)total tip:(long long)tip;

@end
