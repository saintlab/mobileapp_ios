//
//  OMNMenuProductDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductRecommendationsDelimiter.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"

@implementation OMNMenuProductRecommendationsDelimiter {
  
  OMNMenuProductSelectionItem *_menuProductSelectionItem;
  
}

- (instancetype)initWithMenuProductSelectionItem:(OMNMenuProductSelectionItem *)menuProductSelectionItem {
  self = [super init];
  if (self) {
    
    _menuProductSelectionItem = menuProductSelectionItem;
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  if (_menuProductSelectionItem.showRecommendations) {
    
    return 40.0f;
    
  }
  else {
    
    return 0.0f;
    
  }
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductRecommendationsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];
  cell.menuProductSelectionItem = _menuProductSelectionItem;
  return cell;
  
}

@end
