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

- (NSMutableDictionary *)wishParametersWithItems:(NSArray *)items {
  
  NSMutableDictionary *wishParameters = [super wishParametersWithItems:items];
  wishParameters[@"type"] = @"lunch";
  if (self.delivery.address) {
    wishParameters[@"delivery_address"] = self.delivery.addressData;
  }
  if (self.delivery.date) {
    wishParameters[@"delivery_date"] = self.delivery.date;
  }
  return wishParameters;
}

@end
