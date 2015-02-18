//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"
#import <BlocksKit.h>

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

- (void)resetSelection {
  
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    [menuProduct resetSelection];
    
  }];
  
}

- (void)deselectAllProducts {
  
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    menuProduct.selected = NO;
    
  }];
  
}

- (BOOL)hasSelectedItems {
  
  return [self.products bk_any:^BOOL(id key, OMNMenuProduct *menuProduct) {
    
    return (menuProduct.quantity > 0.0);
    
  }];
  
}

- (long long)total {
  
  __block long long total = 0ll;
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    if (menuProduct.quantity) {
      
      total += menuProduct.total;
      
    }
    
  }];
  
  return total;
  
}

@end
