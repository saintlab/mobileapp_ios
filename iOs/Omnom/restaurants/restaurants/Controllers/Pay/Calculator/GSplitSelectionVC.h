//
//  GSplitSelectionVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GCalculatorVCDelegate.h"

@interface GSplitSelectionVC : UIViewController

@property (nonatomic, weak) id<GCalculatorVCDelegate>delegate;

- (instancetype)initWIthTotal:(double)total;

@end


