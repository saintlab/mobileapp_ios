//
//  GMenu.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"

@implementation OMNMenu

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    NSDictionary *productsData = jsonData[@"items"];
    NSMutableDictionary *products = [NSMutableDictionary dictionaryWithCapacity:productsData.count];
    [productsData enumerateKeysAndObjectsUsingBlock:^(id key, id productData, BOOL *stop) {
      
      products[key] = [[OMNMenuProduct alloc] initWithJsonData:productData];
      
    }];
    self.products = products;

    NSArray *categoriesData = jsonData[@"categories"];
    NSMutableArray *categories = [NSMutableArray arrayWithCapacity:categoriesData.count];
    [categoriesData enumerateObjectsUsingBlock:^(id categoryData, NSUInteger idx, BOOL *stop) {
      
      OMNMenuCategory *menuCategory = [[OMNMenuCategory alloc] initWithJsonData:categoryData menuProducts:products level:0];
      [categories addObject:menuCategory];
      
    }];
    self.categories = categories;
    
    
//    id data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menu_stub.json" ofType:nil]] options:kNilOptions error:nil];
//    OMNMenuCategory *mc = [[OMNMenuCategory alloc] initWithJsonData:[data[@"menu"][@"categories"] firstObject] level:0];
//    NSLog(@"%@", mc.listItems);

    
  }
  return self;
}

- (void)resetSelection {
  
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    [menuProduct resetSelection];
    
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
