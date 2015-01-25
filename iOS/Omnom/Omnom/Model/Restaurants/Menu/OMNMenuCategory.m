//
//  OMNMenuCategory.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategory.h"
#import "OMNMenuProductRecommendationsDelimiter.h"
#import "OMNMenuProductsDelimiter.h"

@implementation OMNMenuCategory {
  
  __weak NSDictionary *_menuProducts;
  
}

- (instancetype)initWithJsonData:(id)jsonData menuProducts:(__weak NSDictionary *)menuProducts level:(NSInteger)level {
  self = [super init];
  if (self) {
    
    _menuProducts = menuProducts;
    self.id = [jsonData[@"id"] description];
    self.parent_id = [jsonData[@"parent_id"] description];
    self.name = jsonData[@"name"];
    self.Description = jsonData[@"description"];
    self.sort = jsonData[@"sort"];
    self.schedule = jsonData[@"schedule"];
    self.level = level;
    
    self.products = jsonData[@"items"];

    NSArray *childrenData = jsonData[@"children"];
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:childrenData.count];
    NSInteger nextLevel = level + 1;
    [childrenData enumerateObjectsUsingBlock:^(NSArray *childData, NSUInteger idx, BOOL *stop) {
      
      OMNMenuCategory *menuCategory = [[OMNMenuCategory alloc] initWithJsonData:childData menuProducts:menuProducts level:nextLevel];
      [children addObject:menuCategory];
      
    }];
    self.children = children;
    
  }
  return self;
}

- (NSArray *)listItems {
  
  NSMutableArray *listItems = [NSMutableArray array];
  if (self.level > 1) {
    
    [listItems addObject:self];
    
  }
  
  [self.products enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    OMNMenuProduct *product = _menuProducts[obj];
    [listItems addObject:product];

    if (idx < self.products.count - 1) {
      
      [listItems addObject:[[OMNMenuProductsDelimiter alloc] init]];
      
    }
    
    if (product.recommendations) {
      
      [listItems addObject:[[OMNMenuProductRecommendationsDelimiter alloc] init]];
      
      [product.recommendations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        OMNMenuProduct *product = _menuProducts[obj];
        [listItems addObject:product];

        if (idx < product.recommendations.count - 1) {
          
          [listItems addObject:[[OMNMenuProductsDelimiter alloc] init]];
          
        }
        
      }];
      
    }
    
  }];

  [self.children enumerateObjectsUsingBlock:^(OMNMenuCategory *menuCategory, NSUInteger idx, BOOL *stop) {
    
    [listItems addObjectsFromArray:menuCategory.listItems];
    
  }];
  return listItems;
  
}

- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, name = %@, level = %ld",NSStringFromClass(self.class), self.name, (long)self.level];
  
}

@end
