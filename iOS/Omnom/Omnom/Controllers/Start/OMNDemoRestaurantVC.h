//
//  OMNDemoRestaurantVC.h
//  omnom
//
//  Created by tea on 18.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"

@class OMNVisitor;
@protocol OMNDemoRestaurantVCDelegate;

@interface OMNDemoRestaurantVC : OMNLoadingCircleVC

@property (nonatomic, strong) OMNVisitor *decodeBeacon;
@property (nonatomic, weak) id<OMNDemoRestaurantVCDelegate> delegate;

@end

@protocol OMNDemoRestaurantVCDelegate <NSObject>

- (void)demoRestaurantVCDidFinish:(OMNDemoRestaurantVC *)demoRestaurantVC;
- (void)demoRestaurantVCDidFail:(OMNDemoRestaurantVC *)demoRestaurantVC;

@end
