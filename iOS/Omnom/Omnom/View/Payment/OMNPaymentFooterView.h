//
//  GPaymentFooterView.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@interface OMNPaymentFooterView : UIView

@property (nonatomic, strong) OMNOrder *order;

- (void)updateView;
- (void)setKeyboardShown:(BOOL)keyboardShown;

@end
