//
//  OMNBill.m
//  omnom
//
//  Created by tea on 29.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBill.h"

@implementation OMNBill

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    self.id = [jsonData[@"id"] description];
    self.mail_restaurant_id = jsonData[@"mail_restaurant_id"];
    self.table_id = jsonData[@"table_id"];
    self.revenue = [jsonData[@"revenue"] doubleValue];
    
  }
  return self;
}

@end
