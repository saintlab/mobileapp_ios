//
//  OMNPayOrderVC.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderVCDelegate.h"

@class OMNOrder;

@interface OMNPayOrderVC : UIViewController

@property (nonatomic, weak) id<OMNOrderVCDelegate> delegate;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end
