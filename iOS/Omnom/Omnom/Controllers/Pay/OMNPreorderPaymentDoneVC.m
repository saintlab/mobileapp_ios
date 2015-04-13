//
//  OMNPreorderPaymentDoneVC.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderPaymentDoneVC.h"
#import "NSString+omn_date.h"

@implementation OMNPreorderPaymentDoneVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.textLabel.text = [NSString stringWithFormat:kOMN_PREORDER_DONE_FORMAT, [[NSString omn_takeAfterIntervalString:self.visitor.delivery.minutes] lowercaseString], self.visitor.restaurant.address.text];
  
}

@end
