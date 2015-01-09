//
//  OMNModalAlertVC.h
//  omnom
//
//  Created by tea on 08.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNModalAlertVC : UIViewController

@property (nonatomic, strong, readonly) UIView *fadeView;
@property (nonatomic, strong, readonly) UIView *alertView;
@property (nonatomic, strong, readonly) UIView *contentView;

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end
