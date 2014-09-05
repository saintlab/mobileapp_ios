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
  
  self.sectionInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
  self.itemSize = CGSizeMake(320.0f, 420.0f);
  self.minimumLineSpacing = -40.0f;
  
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
  [attributes enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *obj, NSUInteger idx, BOOL *stop) {
    obj.transform = CGAffineTransformMakeScale(0.85f, 0.85f);
  }];
  return attributes;
  
}

@end
