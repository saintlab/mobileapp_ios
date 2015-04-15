//
//  OMNOrderToolbarButton.m
//  omnom
//
//  Created by tea on 17.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrderToolbarButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNUtils.h"

@implementation OMNOrderToolbarButton

- (instancetype)initWithTotalAmount:(long long)totalAmount  target:(id)target action:(SEL)action {
  
  NSString *callBillTitle = ((totalAmount > 0ll)) ? ([OMNUtils formattedMoneyStringFromKop:totalAmount]) : (kOMN_BILL_CALL_BUTTON_TITLE);
  
  self = [OMNOrderToolbarButton omn_barButtonWithTitle:callBillTitle image:[UIImage imageNamed:@"bill_icon_small"] color:[UIColor blackColor] target:target action:action];
  if (self) {
  }
  return self;
}

@end
