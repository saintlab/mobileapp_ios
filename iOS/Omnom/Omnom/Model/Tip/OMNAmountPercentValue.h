//
//  OMNAmountPercentValue.h
//  omnom
//
//  Created by tea on 03.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNAmountPercentValue : NSObject

@property (nonatomic, assign) long long totalAmount;
@property (nonatomic, assign) long long amount;
@property (nonatomic, assign) double percent;
@property (nonatomic, assign) BOOL isAmountSelected;

@end
