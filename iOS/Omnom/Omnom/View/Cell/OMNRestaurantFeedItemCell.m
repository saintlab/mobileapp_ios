//
//  OMNRestaurantFeedItemCell.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantFeedItemCell.h"
#import <UIImageView+AFNetworking.h>
#import "OMNFeedItem.h"
#import <SDWebImageManager.h>

@implementation OMNRestaurantFeedItemCell {
  OMNFeedItem *_feedItem;
  BOOL _constraintsUpdated;
  UILabel *_textLabel;
  UILabel *_priceLabel;
  UIActivityIndicatorView *_spinner;

}

- (void)dealloc {
  @try {
    [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))];
  }
  @catch (NSException *exception) {
  }
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    _iconView = [[UIImageView alloc] init];
    _iconView.clipsToBounds = YES;
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    _iconView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:_iconView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    _spinner.hidesWhenStopped = YES;
    [_iconView addSubview:_spinner];
    
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

- (void)setFeedItem:(OMNFeedItem *)feedItem {
  
  [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))];
  
  _feedItem = feedItem;
  [_feedItem addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:NULL];
  
  _textLabel.text = feedItem.title;
  _priceLabel.text = feedItem.price;
  _iconView.image = feedItem.image;
  
  if (nil == _feedItem.image) {
    [_spinner startAnimating];
    [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:feedItem.imageURL] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
      
      feedItem.image = image;
      
    }];
    
  }
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))]) {
    [_spinner stopAnimating];
    _iconView.alpha = 0.0f;
    _iconView.image = _feedItem.image;
    [UIView animateWithDuration:0.3 animations:^{
      _iconView.alpha = 1.0f;
    }];
    
  }
  
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
    @"imageView" : _iconView,
    @"spinner" : _spinner,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-15-[textLabel][priceLabel(>=70@1000)]-15-|" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(250)][textLabel(30)]" options:0 metrics:0 views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceLabel(==textLabel)]" options:0 metrics:0 views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  [_iconView addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_iconView addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

@end
