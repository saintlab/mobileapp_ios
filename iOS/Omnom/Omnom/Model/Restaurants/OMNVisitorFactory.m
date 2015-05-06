//
//  OMNVisitorFactory.m
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitorFactory.h"
#import "OMNDemoVisitor.h"
#import "OMNBarVisitor.h"
#import "OMNLunchVisitor.h"
#import "OMNPreorderVisitor.h"
#import "OMNRestaurantInVisitor.h"
#import "OMNTableVisitor.h"

@implementation OMNVisitorFactory

+ (OMNVisitor *)visitorForRestaurant:(OMNRestaurant *)restaurant {
  
  if (restaurant.is_demo) {
    return [OMNDemoVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  
  OMNVisitor *visitor = nil;
  if ([restaurant.entrance_mode isEqualToString:kEntranceModeBar]) {
    visitor = [OMNBarVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  else if ([restaurant.entrance_mode isEqualToString:kEntranceModeLunch]) {
    visitor = [OMNLunchVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  else if ([restaurant.entrance_mode isEqualToString:kEntranceModeTakeAway]) {
    visitor = [OMNPreorderVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  else if ([restaurant.entrance_mode isEqualToString:kEntranceModeIn]) {
    visitor = [OMNRestaurantInVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  else {
    visitor = [OMNVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  return visitor;
  
}

+ (NSArray *)visitorsForRestaurant:(OMNRestaurant *)restaurant {
  
  NSMutableArray *visitors = [NSMutableArray arrayWithCapacity:restaurant.entrance_modes.count];
  if ([restaurant.entrance_modes containsObject:kEntranceModeBar]) {
    [visitors addObject:[OMNBarVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]];
  }
  
  if ([restaurant.entrance_modes containsObject:kEntranceModeIn]) {
    [visitors addObject:[OMNRestaurantInVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]];
  }
  
  if ([restaurant.entrance_modes containsObject:kEntranceModeLunch]) {
    [visitors addObject:[OMNLunchVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]];
  }
  
  if ([restaurant.entrance_modes containsObject:kEntranceModeTakeAway]) {
    [visitors addObject:[OMNPreorderVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]];
  }
  
  if ([restaurant.entrance_modes containsObject:kEntranceModeOnTable]) {
    [visitors addObject:[OMNTableVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]]];
  }
  
  return visitors;
  
}

@end
