//
//  OMNMenuCategory.m
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategory.h"
#import "OMNMenuProductRecommendationsDelimiterCellItem.h"
#import "OMNMenuProductsDelimiterCellItem.h"
#import "OMNMenuProductWithRecommedtations.h"
#import <BlocksKit.h>

@implementation OMNMenuCategory

- (instancetype)initWithJsonData:(id)jsonData menuProducts:(__weak NSDictionary *)menuProducts level:(NSInteger)level {
  self = [super init];
  if (self) {
    
    _allProducts = menuProducts;
    self.id = [jsonData[@"id"] description];
    self.parent_id = [jsonData[@"parent_id"] description];
    self.name = jsonData[@"name"];
    self.Description = jsonData[@"description"];
    self.sort = jsonData[@"sort"];
    self.schedule = jsonData[@"schedule"];
    self.level = level;
    
    self.products = jsonData[@"items"];

    NSArray *childrenData = jsonData[@"children"];
    NSInteger nextLevel = level + 1;
    self.children = [childrenData bk_map:^id(id childData) {
      
      return [[OMNMenuCategory alloc] initWithJsonData:childData menuProducts:menuProducts level:nextLevel];
      
    }];
    
  }
  return self;
}

- (NSString *)description {
  
  return [NSString stringWithFormat:@"%@, name = %@, level = %ld",NSStringFromClass(self.class), self.name, (long)self.level];
  
}

@end
