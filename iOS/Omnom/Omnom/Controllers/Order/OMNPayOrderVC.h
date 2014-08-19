//
//  GPaymentVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNOrder;
@class OMNDecodeBeacon;
@protocol OMNPayOrderVCDelegate;

@interface OMNPayOrderVC : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) id<OMNPayOrderVCDelegate> delegate;

- (instancetype)initWithDecodeBeacon:(OMNDecodeBeacon *)decodeBeacon order:(OMNOrder *)order;

@end

@protocol OMNPayOrderVCDelegate <NSObject>

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC;

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC;

@end