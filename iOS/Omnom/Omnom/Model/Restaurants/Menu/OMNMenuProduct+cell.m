//
//  OMNMenuProduct+cell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductView.h"
#import "OMNMenuProductCell.h"
#import "OMNPreorderConfirmCell.h"
#import "OMNMenuProductRecommendationsDelimiter.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"
#import "OMNMenuProductsDelimiterCell.h"
#import "OMNMenuProductsDelimiter.h"
#import <OMNStyler.h>

@implementation OMNMenuProduct (cell)

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (self.calculationHeight > 0.0f) {
    return self.calculationHeight;
  }
  
  static OMNMenuProductView *menuProductView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    menuProductView = [[OMNMenuProductView alloc] initWithFrame:tableView.bounds];
  });
  
  menuProductView.bounds = tableView.bounds;
  menuProductView.menuProduct = self;
  [menuProductView setNeedsLayout];
  [menuProductView layoutIfNeeded];
  
  CGFloat height = [menuProductView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  self.calculationHeight = height;
  
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  cell.menuProduct = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  [tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  [tableView registerClass:[OMNMenuProductRecommendationsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];

}

- (CGFloat)preorderHeightForTableView:(UITableView *)tableView {
  
  static OMNPreorderConfirmView *preorderConfirmView = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    preorderConfirmView = [[OMNPreorderConfirmView alloc] initWithFrame:tableView.bounds];
  });
  
  preorderConfirmView.bounds = tableView.bounds;
  preorderConfirmView.menuProduct = self;
  [preorderConfirmView setNeedsLayout];
  [preorderConfirmView layoutIfNeeded];
  
  CGFloat height = [preorderConfirmView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  
  return height;
  
}

- (NSArray *)recommendationListWithProducts:(NSDictionary *)products {
  
  NSMutableArray *recommendationList  = [NSMutableArray array];
  
  NSInteger recommendationsCount = self.recommendations.count;
  if (recommendationsCount > 0) {
    
    [recommendationList addObject:@[[[OMNMenuProductRecommendationsDelimiter alloc] init]]];
    
    NSMutableArray *recommendations = [NSMutableArray arrayWithCapacity:self.recommendations.count];
    [self.recommendations enumerateObjectsUsingBlock:^(id productID, NSUInteger idx, BOOL *stop) {
      
      OMNMenuProduct *recommendationProduct = products[productID];
      [recommendations addObject:recommendationProduct];
      
      OMNMenuProductsDelimiter *menuProductsDelimiter = [[OMNMenuProductsDelimiter alloc] init];
      menuProductsDelimiter.type = (idx < recommendationsCount - 1) ? (kMenuProductsDelimiterTypeGray) : (kMenuProductsDelimiterTypeRecommendations);
      [recommendations addObject:menuProductsDelimiter];
      
    }];
    
    [recommendationList addObject:recommendations];
    
  }
  
  return recommendationList;
  
}

@end
