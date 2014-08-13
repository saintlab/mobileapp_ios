//
//  OMNRestaurantFeedItemCell.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantFeedItemCell.h"
#import <UIImageView+AFNetworking.h>

@implementation OMNRestaurantFeedItemCell {
  NSDictionary *_feedItem;
  BOOL _constraintsUpdated;
  UIImageView *_imageView;
  UILabel *_textLabel;
  UILabel *_priceLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imageView sizeToFit];
    [self.contentView addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_textLabel];
    
    _priceLabel = [[UILabel alloc] init];
    _priceLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_priceLabel];
  }
  return self;
}

- (void)setFeedItem:(NSDictionary *)feedItem {
  _feedItem = feedItem;
  _textLabel.text = feedItem[@"title"];
  _priceLabel.text = feedItem[@"price"];
  [_imageView setImageWithURL:[NSURL URLWithString:feedItem[@"image"]]];
  
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
    @"textLabel" : _textLabel,
    @"priceLabel" : _priceLabel,
    @"imageView" : _imageView,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[textLabel][priceLabel(>=70@1000)]-15-|" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(250)][textLabel(50)]" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceLabel(==textLabel)]" options:0 metrics:0 views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

@end
