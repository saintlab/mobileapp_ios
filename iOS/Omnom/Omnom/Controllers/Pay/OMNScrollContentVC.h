//
//  OMNPaymentDoneVC.h
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNBackgroundVC.h"

@interface OMNScrollContentVC : OMNBackgroundVC

@property (nonatomic, copy) dispatch_block_t didFinishBlock;
@property (nonatomic, strong, readonly) UIView *contentView;

@end
