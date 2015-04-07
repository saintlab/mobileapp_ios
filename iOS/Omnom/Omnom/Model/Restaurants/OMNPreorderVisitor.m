//
//  OMNPreorderVisitor.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderVisitor.h"
#import "OMNPreorderRestaurantMediator.h"
#import "OMNOperationManager.h"

@implementation OMNPreorderVisitor

- (OMNRestaurantMediator *)mediatorWithRootVC:(OMNRestaurantActionsVC *)rootVC {
  return [[OMNPreorderRestaurantMediator alloc] initWithVisitor:self rootViewController:rootVC];
}

@end
