//
//  GCalculationAmount.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@class OMNTipButton;



@interface OMNCalculationAmount : NSObject

//- (instancetype)initWithOrder:(OMNOrder *)order;

@property (nonatomic, strong, readonly) NSMutableArray *tips;

@end
