//
//  OMNOrderItemCell.m
//  restaurants
//
//  Created by tea on 02.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItemCell.h"

@implementation OMNOrderItemCell {
  UILabel *_label;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor whiteColor];

      UIImageView *bgIV = [[UIImageView alloc] initWithFrame:self.bounds];
      bgIV.image = [UIImage imageNamed:@"bill_bg"];
      bgIV.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
      [self addSubview:bgIV];
      
      _label = [[UILabel alloc] initWithFrame:self.bounds];
      _label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
      _label.numberOfLines = 0;
      [self addSubview:_label];
      
    }
    return self;
}

- (void)setOrder:(OMNOrder *)order {
  _order = order;
  
  NSMutableString *str = [NSMutableString stringWithString:@""];
  [str appendFormat:@"%@\n", order.restaurant_id];
  [str appendFormat:@"%@\n", order.tableId];
  [order.items enumerateObjectsUsingBlock:^(OMNOrderItem *item, NSUInteger idx, BOOL *stop) {
    [str appendFormat:@"%@\n", item.name];
  }];
  
  _label.text = str;
}

@end
