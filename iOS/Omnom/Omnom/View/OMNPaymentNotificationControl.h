//
//  OMNPaymentNotificationControl.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNPaymentNotificationControl : UIView

+ (void)showWithPaymentData:(NSDictionary *)paymentData;
+ (void)playPaySound;

@end
