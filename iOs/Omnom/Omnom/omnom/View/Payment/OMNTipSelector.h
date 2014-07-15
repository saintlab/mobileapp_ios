//
//  GTipSelector.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculationAmount.h"

@interface OMNTipSelector : UIControl

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) OMNCalculationAmount *calculationAmount;

- (void)update;

@end
