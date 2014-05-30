//
//  GTipSelector.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GCalculationAmount.h"

@interface GTipSelector : UIControl

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) GCalculationAmount *calculationAmount;

- (void)update;

@end
