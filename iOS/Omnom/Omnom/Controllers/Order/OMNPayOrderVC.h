//
//  GPaymentVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNOrder;
@class OMNVisitor;
@protocol OMNPayOrderVCDelegate;

@interface OMNPayOrderVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<OMNPayOrderVCDelegate> delegate;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

@end

@protocol OMNPayOrderVCDelegate <NSObject>

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC;
- (void)payOrderVCRequestOrders:(OMNPayOrderVC *)ordersVC;
- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC;

@end