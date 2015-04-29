//
//  OMNForbiddenWishProducts.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNForbiddenWishProducts.h"

@implementation OMNForbiddenWishProducts

- (instancetype)initWithJsonData:(id)jsonData {
  
  if (![jsonData isKindOfClass:[NSArray class]]) {
    return nil;
  }
  
  self = [super init];
  if (self) {
    
    NSArray *products = jsonData;
    _ids = [NSMutableArray arrayWithCapacity:products.count];
    _names = [NSMutableArray arrayWithCapacity:products.count];
    
    [products enumerateObjectsUsingBlock:^(id product, NSUInteger idx, BOOL *stop) {

      if (product[@"id"]) {
        [_ids addObject:product[@"id"]];
      }
      
      if (product[@"name"]) {
        [_names addObject:product[@"name"]];
      }
      
    }];

  }
  return self;
}

@end
