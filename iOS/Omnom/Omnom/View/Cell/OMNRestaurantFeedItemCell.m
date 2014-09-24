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
#import "OMNImageManager.h"

@implementation OMNRestaurantFeedItemCell {
  OMNFeedItem *_feedItem;
  UILabel *_textLabel;
  UILabel *_priceLabel;
  UIActivityIndicatorView *_spinner;

}

- (void)dealloc {
  @try {
    [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))];
    [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(thumbImage))];
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
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(180)][textLabel(44)]" options:0 metrics:0 views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceLabel(==textLabel)]" options:0 metrics:0 views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    
    [_iconView addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [_iconView addConstraint:[NSLayoutConstraint constraintWithItem:_spinner attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_iconView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  return self;
}

- (void)setFeedItem:(OMNFeedItem *)feedItem {
  
  [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(image))];
  [_feedItem removeObserver:self forKeyPath:NSStringFromSelector(@selector(thumbImage))];
  
  _feedItem = feedItem;
  [_feedItem addObserver:self forKeyPath:NSStringFromSelector(@selector(image)) options:NSKeyValueObservingOptionNew context:NULL];
  [_feedItem addObserver:self forKeyPath:NSStringFromSelector(@selector(thumbImage)) options:NSKeyValueObservingOptionNew context:NULL];
  
  _textLabel.text = feedItem.title;
  _priceLabel.text = feedItem.price;
  
  if (_feedItem.image) {
    _iconView.image = _feedItem.image;
  }
  else if (_feedItem.thumbImage) {

    _iconView.image = _feedItem.thumbImage;
    [_spinner startAnimating];
    [_feedItem downloadImage];

  }
  else {
    
    [_spinner startAnimating];
    [[OMNImageManager manager] downloadBlurredImageWithURL:feedItem.imageURL expectedSize:CGSizeMake(320.0f, 305.0f) completion:^(UIImage *image) {
      
      feedItem.thumbImage = image;
      [feedItem downloadImage];
      
    }];
    
  }
  
}

- (void)updateFeedItemImage {
  
  if ([_iconView.image isEqual:_feedItem.image]) {
    return;
  }
  
  if (_feedItem.image) {
    
    [_spinner stopAnimating];
    [self setImageAnimated:_feedItem.image];
    
  }
  else if (![_iconView.image isEqual:_feedItem.thumbImage]) {
    
    [self setImageAnimated:_feedItem.thumbImage];
    
  }
  
}

- (void)setImageAnimated:(UIImage *)image {
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:_iconView.bounds];
  iv.clipsToBounds = YES;
  iv.image = image;
  iv.contentMode = UIViewContentModeScaleAspectFill;
  iv.alpha = 0.0f;
  [_iconView addSubview:iv];
  
  [UIView animateWithDuration:0.6 animations:^{
    iv.alpha = 1.0f;
  } completion:^(BOOL finished) {
    [iv removeFromSuperview];
    _iconView.image = image;
  }];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))] ||
      [keyPath isEqualToString:NSStringFromSelector(@selector(thumbImage))]) {
    
    [self updateFeedItemImage];
    
  }
  
}

@end
