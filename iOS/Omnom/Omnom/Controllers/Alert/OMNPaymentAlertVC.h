//
//  OMNPaymentAlertVC.h
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNModalAlertVC.h"

@interface OMNPaymentAlertVC : OMNModalAlertVC

@property (nonatomic, copy) dispatch_block_t didPayBlock;

- (instancetype)initWithText:(NSString *)text detailedText:(NSString *)detailedText amount:(long long)amount;

@end
