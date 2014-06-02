//
//  GPaymentFooterView.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculationAmount.h"

@protocol GPaymentFooterViewDelegate;

@interface GPaymentFooterView : UIView

@property (nonatomic, strong) OMNCalculationAmount *calculationAmount;

- (void)updateView;

@end
