//
//  GPaymentVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNOrderTableView.h"

@class OMNOrder;
@class OMNVisitor;
@protocol OMNPayOrderVCDelegate;

@interface OMNPayOrderVC : OMNBackgroundVC

@property (nonatomic, strong) OMNOrderTableView *tableView;
@property (nonatomic, weak) id<OMNPayOrderVCDelegate> delegate;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

@end

@protocol OMNPayOrderVCDelegate <NSObject>

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC;
- (void)payOrderVCRequestOrders:(OMNPayOrderVC *)ordersVC;
- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC;

@end