//
//  OMNTravelersVisitor.m
//  omnom
//
//  Created by tea on 13.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantInVisitor.h"
#import "OMNRestaurantInMediator.h"

@implementation OMNRestaurantInVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNRestaurantInMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

@end
