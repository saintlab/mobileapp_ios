//
//  UITableViewCell+omn_height.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "UITableViewCell+omn_height.h"

@implementation UITableViewCell (omn_height)

- (CGFloat)omn_compressedHeight {
  
  [self setNeedsLayout];
  [self layoutIfNeeded];
  
  CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
  
  // Add an extra point to the height to account for the cell separator, which is added between the bottom
  // of the cell's contentView and the bottom of the table view cell.
  height += 1.0f;
  
  return height;
  
}

@end
