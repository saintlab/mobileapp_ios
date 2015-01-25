//
//  OMNMenuProductDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductRecommendationsDelimiter.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"

@implementation OMNMenuProductRecommendationsDelimiter

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  return 40.0f;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductRecommendationsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];
  return cell;
  
}

@end
