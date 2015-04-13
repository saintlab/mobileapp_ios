//
//  OMNRestaurantInMediator.m
//  omnom
//
//  Created by tea on 13.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantInMediator.h"
#import "OMNRestaurantInWishMediator.h"

@implementation OMNRestaurantInMediator

- (BOOL)showTableButton {
  return NO;
}

- (BOOL)showPreorderButton {
  return YES;
}

- (OMNWishMediator *)wishMediatorWithRootVC:(OMNMyOrderConfirmVC *)rootVC {
  return [[OMNRestaurantInWishMediator alloc] initWithRestaurantMediator:self rootVC:rootVC];
}

@end
