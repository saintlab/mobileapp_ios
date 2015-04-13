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

@implementation OMNVisitorFactory

+ (OMNVisitor *)visitorForRestaurant:(OMNRestaurant *)restaurant {
  
  if (restaurant.is_demo) {
    return [OMNDemoVisitor visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
  }
  
  OMNVisitor *visitor = nil;
  switch (restaurant.entrance_mode) {
    case kRestaurantModeBar: {
      
      visitor = [OMNBarVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } break;
    case kRestaurantModeLunch: {
      
      visitor = [OMNLunchVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } break;
    case kRestaurantModePreorder: {

      visitor = [OMNPreorderVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } break;
    case kRestaurantModeIn: {
      
      visitor = [OMNRestaurantInVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } break;
    default: {
      
      visitor = [OMNVisitor  visitorWithRestaurant:restaurant delivery:[OMNDelivery delivery]];
      
    } break;
      
  }
  
  return visitor;
  
}

@end
