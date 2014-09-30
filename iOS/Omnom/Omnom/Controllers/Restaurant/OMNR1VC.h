//
//  OMNR1VC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@class OMNRestaurantMediator;
@class OMNVisitor;
@protocol OMNR1VCDelegate;

@interface OMNR1VC : OMNCircleRootVC

@property (nonatomic, strong, readonly) OMNVisitor *visitor;
@property (nonatomic, assign, readonly) BOOL isViewVisible;

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator;

@end

