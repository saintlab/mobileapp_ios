//
//  OMNMenuProductFullWithRecommendationsCellItem.m
//  omnom
//
//  Created by tea on 25.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductFullWithRecommendationsCellItem.h"
#import "OMNMenuProductFullCellItem.h"

@implementation OMNMenuProductFullWithRecommendationsCellItem

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super initWithMenuProduct:menuProduct products:products];
  if (self) {
    
    self.menuProductCellItem = [[OMNMenuProductFullCellItem alloc] initWithMenuProduct:menuProduct];
    
  }
  return self;
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductFullWithRecommendationsCellItem class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductFullWithRecommendationsCellItem class])];
  
}

+ (void)registerProductWithRecommendationsCellForTableView:(UITableView *)tableView {
  
  [super registerProductWithRecommendationsCellForTableView:tableView];
  [OMNMenuProductFullCellItem registerCellForTableView:tableView];
  
}

@end
