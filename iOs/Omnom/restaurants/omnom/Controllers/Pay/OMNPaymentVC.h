//
//  OMNPaymentVC.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class OMNBankCard;
@class OMNOrder;
@protocol OMNPaymentVCDelegate;

@interface OMNPaymentVC : UIViewController

@property (nonatomic, weak) id<OMNPaymentVCDelegate> delegate;

- (instancetype)initWithCard:(OMNBankCard *)bankCard order:(OMNOrder *)order;

@end

@protocol OMNPaymentVCDelegate <NSObject>

- (void)paymentVCDidFinish:(OMNPaymentVC *)paymentVC;

@end