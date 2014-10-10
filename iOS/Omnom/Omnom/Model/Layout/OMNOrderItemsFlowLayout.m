//
//  OMNOrderItemsFlowLayout.m
//  omnom
//
//  Created by tea on 27.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItemsFlowLayout.h"

@implementation OMNOrderItemsFlowLayout

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  self.sectionInset = UIEdgeInsetsMake(45.0f, 20.0f, 75.0f, 20.0f);
  self.itemSize = CGSizeMake(275.0f, 360.0f);
  self.minimumLineSpacing = 10.0f;
  
}

/*
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
//    obj.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
  }];
  return attributes;
  
}
*/

@end
