//
//  GCalculatorVCDelegate.h
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNCalculatorVC;

@protocol GCalculatorVCDelegate <NSObject>

@optional

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC didFinishWithTotal:(double)total;

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC;


- (void)totalDidChange:(double)total;

@end
