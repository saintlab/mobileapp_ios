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

- (NSString *)tags {
  return kEntranceModeTakeAway;
}
- (NSString *)restarantCardButtonTitle {
  return kOMN_RESTAURANT_MODE_TAKE_AWAY_TITLE;
}
- (NSString *)restarantCardButtonIcon {
  return @"card_ic_takeaway";
}

@end
