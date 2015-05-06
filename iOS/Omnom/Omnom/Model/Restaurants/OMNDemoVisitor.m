//
//  OMNDemoVisitor.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDemoVisitor.h"
#import "OMNDemoRestaurantMediator.h"

@implementation OMNDemoVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNDemoRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

- (NSString *)tags {
  return kEntranceModeDemo;
}

@end
