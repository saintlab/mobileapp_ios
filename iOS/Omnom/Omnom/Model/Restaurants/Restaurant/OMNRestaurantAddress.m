//
//  OMNRestaurantAddress.m
//  omnom
//
//  Created by tea on 24.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantAddress.h"

@implementation OMNRestaurantAddress

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSDictionary class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    _jsonData = jsonData;
    _name = jsonData[@"name"];
    _building = [jsonData[@"building"] description];
    _city = jsonData[@"city"];
    _street = jsonData[@"street"];
    _floor = (jsonData[@"floor"]) ? ([jsonData[@"floor"] description]) : (@"");
    
  }
  return self;
}

- (NSString *)text {
  
  NSMutableString *address = [NSMutableString stringWithString:@""];
  NSMutableArray *streetComponents = [NSMutableArray arrayWithCapacity:2];
  if (self.street.length) {
    [streetComponents addObject:self.street];
  }
  if (self.building.length) {
    [streetComponents addObject:self.building];
  }

  [address appendString:[streetComponents componentsJoinedByString:@", "]];
  
  if (self.floor.length) {
    
    [address appendFormat:NSLocalizedString(@"RESTAURANT_ADDRESS_FLOOR %@", @", {NUMBER} этаж"), self.floor];
    
  }
  
  return address;
  
}

@end
