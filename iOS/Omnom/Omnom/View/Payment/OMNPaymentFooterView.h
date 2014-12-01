//
//  GPaymentFooterView.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@protocol OMNPaymentFooterViewDelegate;

@interface OMNPaymentFooterView : UIView

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, weak) id <OMNPaymentFooterViewDelegate> delegate;

- (void)updateView;
- (void)setKeyboardShown:(BOOL)keyboardShown;

@end

@protocol OMNPaymentFooterViewDelegate <NSObject>

- (void)paymentFooterView:(OMNPaymentFooterView *)paymentFooterView didSelectAmount:(long long)amount;

@end
