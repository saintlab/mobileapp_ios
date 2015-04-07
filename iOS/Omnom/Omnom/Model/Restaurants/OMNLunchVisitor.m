//
//  OMNLunchVisitor.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchVisitor.h"
#import "OMNLunchRestaurantMediator.h"
@implementation OMNLunchVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNLunchRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

@end
