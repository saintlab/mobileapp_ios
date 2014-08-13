//
//  OMNRestaurantInfoCell.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoCell.h"
#import "OMNRestaurantInfoItem.h"

@implementation OMNRestaurantInfoCell {
  BOOL _constraintsUpdated;
  OMNRestaurantInfoItem *_restaurantInfoItem;
  UIImageView *_iconView;
  UILabel *_label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeCenter;
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [_iconView sizeToFit];
    [self.contentView addSubview:_iconView];
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
    _label.numberOfLines = 0;
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_label];
    
  }
  return self;
}

- (void)setItem:(OMNRestaurantInfoItem *)item {
  _restaurantInfoItem = item;
  _iconView.image = [item icon];
  _label.text = item.title;
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (_constraintsUpdated) {
    return;
  }
  
  _constraintsUpdated = YES;
  
  NSDictionary *views =
  @{
    @"contentView" : self.contentView,
    @"label" : _label,
    @"iconView" : _iconView,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[iconView(40)]-[label]|" options:0 metrics:0 views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iconView(40)]" options:0 metrics:0 views:views]];
  
}

@end
