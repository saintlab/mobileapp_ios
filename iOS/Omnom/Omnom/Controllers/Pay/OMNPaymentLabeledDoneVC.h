//
//  OMNPaymentLabeledDoneVC.h
//  omnom
//
//  Created by tea on 13.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNScrollContentVC.h"
#import "OMNWish.h"

@interface OMNPaymentLabeledDoneVC : OMNScrollContentVC

@property (nonatomic, strong, readonly) UILabel *textLabel;
@property (nonatomic, strong, readonly) OMNWish *wish;

- (instancetype)initWithWish:(OMNWish *)wish;

@end
