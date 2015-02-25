//
//  OMNMenuProductDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductRecommendationsDelimiterCellItem.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"

@implementation OMNMenuProductRecommendationsDelimiterCellItem {
  
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 40.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductRecommendationsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductRecommendationsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];
  
}

@end
