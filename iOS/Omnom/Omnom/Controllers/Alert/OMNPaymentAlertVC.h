//
//  OMNPaymentAlertVC.h
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNPaymentAlertVC : UIViewController

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailedText;
@property (nonatomic, strong) UIView *fadeView;
@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, copy) dispatch_block_t didPayBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end
