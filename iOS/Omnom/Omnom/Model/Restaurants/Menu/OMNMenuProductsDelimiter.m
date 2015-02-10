//
//  OMNMenuProductsDelimiter.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiter.h"
#import "OMNMenuProductsDelimiterCell.h"
#import <OMNStyler.h>

@implementation OMNMenuProductsDelimiter

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  
  CGFloat height = 2.0f;
  switch (self.type) {
    case kMenuProductsDelimiterTypeNone: {
      
    } break;
    case kMenuProductsDelimiterTypeGray: {
      
    } break;
    case kMenuProductsDelimiterTypeRecommendations: {
      height = 20.0f;
    } break;
  }
  return height;
  
}

- (UITableViewCell *)cellForTableView:(UITableView *)tableView {
  
  OMNMenuProductsDelimiterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  cell.menuProductsDelimiter = self;
  return cell;
  
}

+ (void)registerCellForTableView:(UITableView *)tableView {
  
  [tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  
}

@end
