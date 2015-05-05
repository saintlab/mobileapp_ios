//
//  OMNSearchRestaurantMediator.h
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNVisitor.h"

@interface OMNSearchRestaurantMediator : NSObject

@property (nonatomic, weak, readonly) UIViewController *rootVC;

- (instancetype)initWithRootVC:(__weak UIViewController *)vc;

- (void)searchRestarants;
- (void)showSettings;
- (void)scanTableQrTap;
- (void)demoModeTap;
- (void)showVisitor:(OMNVisitor *)visitor;
- (void)showRestaurants:(NSArray *)restaurants;

@end
