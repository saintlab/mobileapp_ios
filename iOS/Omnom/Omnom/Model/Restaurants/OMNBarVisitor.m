//
//  OMNBarVisitor.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarVisitor.h"
#import "OMNBarRestaurantMediator.h"

@implementation OMNBarVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNBarRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

@end
