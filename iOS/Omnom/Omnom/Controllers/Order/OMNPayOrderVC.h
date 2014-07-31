//
//  GPaymentVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNOrder;
@class OMNRestaurant;
@protocol OMNPayOrderVCDelegate;

@interface OMNPayOrderVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<OMNPayOrderVCDelegate> delegate;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant order:(OMNOrder *)order;

@end

@protocol OMNPayOrderVCDelegate <NSObject>

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC;

@end