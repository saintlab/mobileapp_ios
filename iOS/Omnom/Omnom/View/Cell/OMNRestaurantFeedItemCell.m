//
//  OMNRestaurantFeedItemCell.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantFeedItemCell.h"
#import "OMNFeedItem.h"
#import "OMNImageManager.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

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
    
    UIColor *backgroundColor = [UIColor whiteColor];
    
    self.contentView.backgroundColor = backgroundColor;
    self.contentView.opaque = YES;

    _iconView = [UIImageView omn_autolayoutView];
    _iconView.backgroundColor = backgroundColor;
    _iconView.opaque = YES;
    _iconView.clipsToBounds = YES;
    _iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconView];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.translatesAutoresizingMaskIntoConstraints = NO;
    _spinner.hidesWhenStopped = YES;
    [_iconView addSubview:_spinner];
    
    _textLabel = [UILabel omn_autolayoutView];
    _textLabel.backgroundColor = backgroundColor;
    _textLabel.opaque = YES;
    _textLabel.font = FuturaOSFOmnomRegular(20.0f);
    [self.contentView addSubview:_textLabel];
    
    _priceLabel = [UILabel omn_autolayoutView];
    _priceLabel.backgroundColor = backgroundColor;
    _priceLabel.opaque = YES;
    _priceLabel.font = FuturaOSFOmnomRegular(20.0f);
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_priceLabel];
    
    NSDictionary *views =
    @{
      @"contentView" : self.contentView,
      @"textLabel" : _textLabel,
      @"priceLabel" : _priceLabel,
      @"imageView" : _iconView,
      @"spinner" : _spinner,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : @(OMNStyler.leftOffset),
      };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageView]|" options:kNilOptions metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel][priceLabel(>=70@1000)]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(180)][textLabel(44)]" options:kNilOptions metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[priceLabel(==textLabel)]" options:kNilOptions metrics:nil views:views]];
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
    
    _iconView.image = image;
    [iv removeFromSuperview];
    
  }];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(image))] ||
      [keyPath isEqualToString:NSStringFromSelector(@selector(thumbImage))]) {
    
    [self updateFeedItemImage];
    
  }
  
}

@end
