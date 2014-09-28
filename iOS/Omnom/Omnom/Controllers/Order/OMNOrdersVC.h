//
//  OMNOrdersVC.h
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderVCDelegate.h"
#import "OMNOrder.h"
#import "OMNBackgroundVC.h"

@class OMNVisitor;
@protocol OMNOrdersVCDelegate;

@interface OMNOrdersVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNOrdersVCDelegate> delegate;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, strong, readonly) UICollectionView *collectionView;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

@end

@protocol OMNOrdersVCDelegate <NSObject>

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order;

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC;

@end
