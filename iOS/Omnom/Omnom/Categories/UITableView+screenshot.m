//
//  UITableView+screenshot.m
//  omnom
//
//  Created by tea on 24.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UITableView+screenshot.h"
#import "UIView+screenshot.h"

@implementation UITableView (screenshot)

- (UIImage *)omn_screenshotOfSection:(NSInteger)section {
  
  if (section >= self.numberOfSections) {
    return nil;
  }

  CGPoint initialTableViewOffset = self.contentOffset;
  
  NSInteger rowsCount = [self numberOfRowsInSection:section];

  NSMutableArray *cellSnapShots = [NSMutableArray arrayWithCapacity:rowsCount];
  
  CGFloat totalHeight = 0.0f;
  for (NSInteger row = 0; row < rowsCount; row++) {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    
    [self scrollToRowAtIndexPath:indexPath
                atScrollPosition:UITableViewScrollPositionMiddle
                        animated:NO];

    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    totalHeight += CGRectGetHeight(cell.frame);
    UIImage *cellImage = [cell omn_screenshot];

    if (cellImage) {
      [cellSnapShots addObject:cellImage];
    }

  }

  self.contentOffset = initialTableViewOffset;
  
  UIImage *finalImage = [UIView omn_imageFromArray:cellSnapShots];

  return finalImage;
  
}

- (UIImage *)omn_screenshot {
  return [super omn_screenshot];
//  CGRect frame = self.frame;
//  CGRect drawFrame = (CGRect){CGPointZero, self.contentSize};
//  self.frame = drawFrame;
//  [self layoutIfNeeded];
//  [self reloadData];
//  UIGraphicsBeginImageContextWithOptions(drawFrame.size, NO, [UIScreen mainScreen].scale);
//  // Create a graphics context and translate it the view we want to crop so
//  // that even in grabbing (0,0), that origin point now represents the actual
//  // cropping origin desired:
//  
//	[self drawViewHierarchyInRect:drawFrame afterScreenUpdates:YES];
//	UIImage *screenshotImage = UIGraphicsGetImageFromCurrentImageContext();
//  UIGraphicsEndImageContext();
//  
//  self.frame = frame;
//
//  return nil;
}

@end
