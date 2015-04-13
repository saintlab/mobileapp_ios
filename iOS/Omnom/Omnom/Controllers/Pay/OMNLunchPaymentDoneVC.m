//
//  OMNLunchPaymentDoneVC.m
//  omnom
//
//  Created by tea on 06.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchPaymentDoneVC.h"
#import "NSString+omn_date.h"

@implementation OMNLunchPaymentDoneVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSString *date = [NSString stringWithFormat:@"%@ %@", [self.visitor.delivery.date omn_localizedInWeekday], [self.visitor.delivery.date omn_localizedDate]];
  self.textLabel.text = [NSString stringWithFormat:kOMN_LUNCH_DONE_FORMAT, self.visitor.restaurant.address.text, date];
  
}

@end
