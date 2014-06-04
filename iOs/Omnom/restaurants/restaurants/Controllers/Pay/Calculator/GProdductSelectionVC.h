//
//  GProdductSelectionVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GCalculatorVCDelegate.h"

@class OMNOrder;

@interface GProdductSelectionVC : UITableViewController

@property (nonatomic, weak) id<OMNCalculatorVCDelegate>delegate;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end
