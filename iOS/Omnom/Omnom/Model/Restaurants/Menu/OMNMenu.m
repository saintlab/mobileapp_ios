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
    self.modifiers = [modifiersData bk_map:^id(id key, id modifierData) {
      
      return [[OMNMenuModifer alloc] initWithJsonData:modifierData];
      
    }];
    
    NSDictionary *productsData = jsonData[@"items"];
    __weak typeof(self)weakSelf = self;
    self.products = [productsData bk_map:^id(id key, id productData) {
      
      return [[OMNMenuProduct alloc] initWithJsonData:productData allModifers:weakSelf.modifiers];
      
    }];

    NSArray *categoriesData = jsonData[@"categories"];
    __weak NSDictionary *products = self.products;
    self.categories = [categoriesData bk_map:^id(id categoryData) {
      
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
