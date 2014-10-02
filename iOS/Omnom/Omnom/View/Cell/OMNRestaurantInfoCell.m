//
//  OMNRestaurantInfoCell.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoCell.h"
#import "OMNRestaurantInfoItem.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@implementation OMNRestaurantInfoCell {
  OMNRestaurantInfoItem *_restaurantInfoItem;
  UIImageView *_iconView;
  UILabel *_label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    self.contentView.opaque = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _iconView = [[UIImageView alloc] init];
    _iconView.opaque = YES;
    _iconView.contentMode = UIViewContentModeLeft;
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [_iconView sizeToFit];
    [self.contentView addSubview:_iconView];
    
    _label = [[UILabel alloc] init];
    _label.opaque = YES;
    _label.backgroundColor = [UIColor whiteColor];
    _label.font = FuturaOSFOmnomRegular(18.0f);
    _label.numberOfLines = 0;
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_label];
    
    NSDictionary *views =
    @{
      @"contentView" : self.contentView,
      @"label" : _label,
      @"iconView" : _iconView,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : [[OMNStyler styler] leftOffset],
      };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[iconView(20)]-[label]|" options:0 metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:0 metrics:0 views:views]];
    self.separatorInset = UIEdgeInsetsMake(0.0f, [[[OMNStyler styler] leftOffset] floatValue], 0.0f, 0.0f);
  }
  return self;
}

- (void)setItem:(OMNRestaurantInfoItem *)item {
  _restaurantInfoItem = item;
  _iconView.image = [item icon];
  _label.text = item.title;
}

@end
