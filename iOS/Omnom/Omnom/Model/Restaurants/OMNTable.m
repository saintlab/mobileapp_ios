//
//  OMNTable.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTable.h"

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
  NSMutableArray *tables = [NSMutableArray arrayWithCapacity:tablesData.count];
  [tablesData enumerateObjectsUsingBlock:^(id tableData, NSUInteger idx, BOOL *stop) {
    
    OMNTable *table = [[OMNTable alloc] initWithJsonData:tableData];
    [tables addObject:table];
    
  }];
  
  return [tables copy];
  
}

@end