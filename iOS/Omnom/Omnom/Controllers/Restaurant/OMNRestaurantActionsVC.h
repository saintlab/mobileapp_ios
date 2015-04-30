//
//  OMNBackgroundVC+restaurant.h
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNR1VC.h"

@class OMNVisitor;

@interface OMNRestaurantActionsVC : OMNBackgroundVC

@property (nonatomic, strong, readonly) OMNR1VC *r1VC;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;
- (void)showRestaurantAnimated:(BOOL)animated;

@end
