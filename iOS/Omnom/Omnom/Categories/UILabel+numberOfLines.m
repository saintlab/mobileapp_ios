//
//  UILabel+numberOfLines.m
//  omnom
//
//  Created by tea on 26.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UILabel+numberOfLines.h"

@implementation UILabel (numberOfLines)

- (NSInteger)omn_linesCount {
  CGSize constrain = CGSizeMake(self.bounds.size.width, FLT_MAX);
  CGSize size = [self.text boundingRectWithSize:constrain options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:nil].size;
  NSInteger linesCount = ceil(size.height / self.font.lineHeight);
  return linesCount;
}

@end
