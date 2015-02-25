//
//  OMNMenu+wish.m
//  omnom
//
//  Created by tea on 08.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenu+wish.h"

@implementation OMNMenu (wish)

- (NSArray *)selectedWishItems {

  NSMutableArray *selectedWishItems = [NSMutableArray array];
  [self.products enumerateKeysAndObjectsUsingBlock:^(id key, OMNMenuProduct *menuProduct, BOOL *stop) {
    
    if (menuProduct.preordered) {
      
      NSMutableDictionary *wishItem = [NSMutableDictionary dictionary];
      wishItem[@"id"] = menuProduct.id;
      wishItem[@"quantity"] = @(menuProduct.quantity);
      
      if (menuProduct.selectedModifers.count) {
        
        NSMutableArray *selectedModifers = [NSMutableArray arrayWithCapacity:menuProduct.selectedModifers.count];
        [menuProduct.selectedModifers enumerateObjectsUsingBlock:^(id obj, BOOL *stop1) {
          
          [selectedModifers addObject:@{@"id" : obj}];
          
        }];
        wishItem[@"modifiers"] = selectedModifers;
      }
      
      [selectedWishItems addObject:wishItem];
      
    }
    
  }];
  
  return selectedWishItems;
  
}

@end
