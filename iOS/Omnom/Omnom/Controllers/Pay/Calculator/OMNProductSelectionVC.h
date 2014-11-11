//
//  GProdductSelectionVC.h
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVCDelegate.h"

@class OMNOrder;

@interface OMNProductSelectionVC : UITableViewController

@property (nonatomic, strong) NSMutableSet *changedItems;
@property (nonatomic, weak) id<OMNCalculatorVCDelegate>delegate;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end
