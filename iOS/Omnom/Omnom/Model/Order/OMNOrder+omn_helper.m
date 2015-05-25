//
//  OMNOrder+omn_helper.m
//  omnom
//
//  Created by tea on 25.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrder+omn_helper.h"
#import <BlocksKit+UIKit.h>
#import "OMNError.h"

@implementation OMNOrder (omn_helper)

- (PMKPromise *)checkPaymentValue {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    if (!self.paymentValueIsTooHigh) {
      fulfill(nil);
      return;
    }
    
    [UIAlertView bk_showAlertViewWithTitle:kOMN_ORDER_AMOUNT_TOO_LARGE_ALERT_TITLE message:nil cancelButtonTitle:kOMN_ORDER_AMOUNT_TOO_LARGE_ALERT_CANCEL_BUTTON_TITLE otherButtonTitles:@[kOMN_ORDER_AMOUNT_TOO_LARGE_ALERT_PAY_BUTTON_TITLE] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
      if (alertView.cancelButtonIndex == buttonIndex) {
        reject([OMNError omnomErrorFromCode:kOMNErrorCancel]);
      }
      else {
        fulfill(nil);
      }
      
    }];
    
  }];
  
}

@end
