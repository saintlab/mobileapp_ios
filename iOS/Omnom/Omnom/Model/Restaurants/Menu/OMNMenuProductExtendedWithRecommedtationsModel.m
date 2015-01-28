//
//  OMNMenuProductExtendedWithRecommedtationsModel.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductExtendedWithRecommedtationsModel.h"
#import "OMNMenuProductExtended.h"
#import "OMNMenuProductRecommendationsDelimiter.h"

@implementation OMNMenuProductExtendedWithRecommedtationsModel

@synthesize menuProduct=_menuProduct;

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super init];
  if (self) {
    
    _menuProduct = menuProduct;
    
    self.model = [NSMutableArray arrayWithObject:@[[[OMNMenuProductExtended alloc] initWithMenuProduct:menuProduct]]];
    
    if (_menuProduct.recommendations.count) {
      
      [self.model addObject:@[[[OMNMenuProductRecommendationsDelimiter alloc] init]]];
      
      NSMutableArray *recommendations = [NSMutableArray arrayWithCapacity:menuProduct.recommendations.count];
      [menuProduct.recommendations enumerateObjectsUsingBlock:^(id productID, NSUInteger idx, BOOL *stop) {
        
        OMNMenuProduct *recommendationProduct = products[productID];
        [recommendations addObject:recommendationProduct];
        
      }];
      
      [self.model addObject:recommendations];
      
    }
    
  }
  return self;
}

+ (void)registerCellsForTableView:(UITableView *)tableView {
  
  [super registerCellsForTableView:tableView];
  [OMNMenuProductExtended registerCellForTableView:tableView];
  
}

@end
