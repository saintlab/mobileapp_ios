//
//  OMNRestaurantInfoCell.m
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantInfoCell.h"

@implementation OMNRestaurantInfoCell {
  BOOL _constraintsUpdated;
  NSDictionary *_item;
  UIImageView *_iconView;
  UILabel *_label;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    _iconView = [[UIImageView alloc] init];
    _iconView.contentMode = UIViewContentModeCenter;
    _iconView.image = [UIImage imageNamed:@"demo_mode_icon_small"];
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [_iconView sizeToFit];
    [self.contentView addSubview:_iconView];
    
    _label = [[UILabel alloc] init];
    _label.numberOfLines = 0;
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_label];
    
  }
  return self;
}

- (void)setItem:(NSDictionary *)item {
  _item = item;
  _label.text = item[@"title"];
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
