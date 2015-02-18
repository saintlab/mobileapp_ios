//
//  OMNTable.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"
#import <BlocksKit.h>

@implementation OMNTable

- (instancetype)initWithJsonData:(id)data {
  self = [super init];
  if (self) {

    self.id = [data[@"id"] description];
    self.internal_id = data[@"internal_id"];
    self.restaurant_id = data[@"restaurant_id"];
    
  }
  return self;
}

@end

@implementation NSObject (omn_tables)

- (NSArray *)omn_tables {
  
  if (![self isKindOfClass:[NSArray class]]) {
    return @[];
  }
  
  NSArray *tablesData = (NSArray *)self;
  NSArray *tables = [tablesData bk_map:^id(id tableData) {
    
    return [[OMNTable alloc] initWithJsonData:tableData];
    
  }];
  return tables;
  
}

@end