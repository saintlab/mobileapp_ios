//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"
#import <BlocksKit.h>

NSString * const OMNMenuDidResetNotification = @"OMNMenuDidResetNotification";

@implementation OMNMenu

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    NSDictionary *modifiersData = jsonData[@"modifiers"];
    NSDictionary *modifiers = [modifiersData bk_map:^id(id key, id modifierData) {
      
      return [[OMNMenuModifer alloc] initWithJsonData:modifierData];
      
    }];
    _modifiers = modifiers;
    
    NSDictionary *productsData = jsonData[@"items"];
    NSDictionary *products = [productsData bk_map:^id(id key, id productData) {
      
      return [[OMNMenuProduct alloc] initWithJsonData:productData allModifers:modifiers];
      
    }];
    _products = products;

    NSArray *categoriesData = jsonData[@"categories"];
    _categories = [categoriesData bk_map:^id(id categoryData) {
      
      return [[OMNMenuCategory alloc] initWithJsonData:categoryData menuProducts:products level:0];
      
    }];
    
  }
  return self;
}

- (void)removePreorderedItems {
  
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    [menuProduct resetSelection];
    
  }];
  [[NSNotificationCenter defaultCenter] postNotificationName:OMNMenuDidResetNotification object:self];
  
}

- (void)deselectItemsWithIDs:(NSArray *)itemsIDs {
  
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    if ([itemsIDs containsObject:key]) {
      [menuProduct resetSelection];
    }
    
  }];

}

- (BOOL)hasPreorderedItems {
  
  return [self.products bk_any:^BOOL(id key, OMNMenuProduct *menuProduct) {
    
    return (menuProduct.preordered);
    
  }];
  
}

- (long long)preorderedItemsTotal {
  
  __block long long total = 0ll;
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    if (menuProduct.preordered) {
      total += menuProduct.total;
    }
    
  }];
  
  return total;
  
}

@end
