//
//  OMNPaymentAlertVC.h
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNPaymentAlertVC : UIViewController

@property (nonatomic, strong) UIView *fadeView;
@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, copy) dispatch_block_t didPayBlock;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithText:(NSString *)text detailedText:(NSString *)detailedText amount:(long long)amount;

@end
