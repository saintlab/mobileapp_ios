//
//  UIView+frame.m
//  ManageTable
//
//  Created by tea on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIView+frame.h"

@implementation UIView (frame)

- (CGFloat)left {
  
  return self.frame.origin.x;
  
}

- (void)setLeft:(CGFloat)x {
  
  CGRect frame = self.frame;
  
  frame.origin.x = x;
  
  self.frame = frame;
  
}

- (CGFloat)top {
  
  return self.frame.origin.y;
  
}

- (void)setTop:(CGFloat)y {
  
  CGRect frame = self.frame;
  
  frame.origin.y = y;
  
  self.frame = frame;
  
}

- (CGFloat)right {
  
  return self.frame.origin.x + self.frame.size.width;
  
}

- (void)setRight:(CGFloat)right {
  
  CGRect frame = self.frame;
  
  frame.origin.x = right - frame.size.width;
  
  self.frame = frame;
  
}

- (CGFloat)bottom {
  
  return self.frame.origin.y + self.frame.size.height;
  
}

- (void)setBottom:(CGFloat)bottom {
  
  CGRect frame = self.frame;
  
  frame.origin.y = bottom - frame.size.height;
  
  self.frame = frame;
  
}

- (CGFloat)width {
  
  return self.frame.size.width;
  
}

- (void)setWidth:(CGFloat)width {
  
  CGRect frame = self.frame;
  
  frame.size.width = width;
  
  self.frame = frame;
  
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
  
  CGRect frame = self.frame;
  
  frame.size.height = height;
  
  self.frame = frame;
  
}

- (CGFloat)x {
  return self.center.x;
}

- (void)setX:(CGFloat)x {
  
  CGPoint center = self.center;
  center.x = x;
  self.center = center;
  
}

- (CGFloat)y {
  return self.center.y;
}

- (void)setY:(CGFloat)y {
  
  CGPoint center = self.center;
  center.y = y;
  self.center = center;
  
}

@end
