//
//  GCalculatorVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GCalculatorVCDelegate.h"
@class GOrder;

@interface OMNCalculatorVC : UIViewController

@property (nonatomic, weak) id<GCalculatorVCDelegate>delegate;

- (instancetype)initWithOrder:(GOrder *)order;

@end

