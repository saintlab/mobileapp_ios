//
//  NSObject+omn_order.m
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "NSObject+omn_order.h"
#import <BlocksKit.h>

@implementation NSObject (omn_order)

- (NSArray *)omn_decodeOrdersWithError:(OMNError *__autoreleasing *)error {
  
  if (![self isKindOfClass:[NSArray class]]) {
    *error = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
    return nil;
  }
  
  NSArray *ordersData = (NSArray *)self;
  return [ordersData bk_map:^id(id obj) {

    return [[OMNOrder alloc] initWithJsonData:obj];
    
  }];
  
}

@end
