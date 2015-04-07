//
//  OMNPaymentDoneVC.h
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNBackgroundVC.h"
#import "OMNVisitor.h"
#import "OMNWish.h"

@interface OMNPaymentDoneVC : OMNBackgroundVC

@property (nonatomic, copy) dispatch_block_t didFinishBlock;
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong, readonly) OMNWish *wish;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor wish:(OMNWish *)wish;

@end