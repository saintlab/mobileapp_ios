//
//  GCalculatorVCDelegate.h
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNCalculatorVC;
#import "OMNOrder.h"

@protocol OMNCalculatorVCDelegate <NSObject>

@optional

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total;
- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC;
- (void)totalDidChange:(long long)total;

@end
