//
//  OMNRatingProductCell.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingProductCell.h"

@implementation OMNRatingProductCell {
  
  UIImageView *_heartView;
  
}

- (void)dealloc
{
  @try {
    [_product removeObserver:self forKeyPath:NSStringFromSelector(@selector(rated))];
  }
  @catch (NSException *exception) {
  }
}

- (id)initWithFrame:(CGRect)frame {
  
  self = [super initWithFrame:frame];
  if (self) {
    _iconView = [[UIImageView alloc] initWithFrame:self.bounds];
    _iconView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self addSubview:_iconView];
    
    _heartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"heart_icon"]];
    _heartView.center = CGPointMake(CGRectGetWidth(self.frame)/2.0f, CGRectGetHeight(self.frame)/2.0f);
    [self addSubview:_heartView];
    
  }
  return self;
}

- (void)setProduct:(OMNProduct *)product {
  
  [_product removeObserver:self forKeyPath:NSStringFromSelector(@selector(rated))];
  _product = product;
  [_product addObserver:self forKeyPath:NSStringFromSelector(@selector(rated)) options:NSKeyValueObservingOptionNew context:NULL];
  
  _iconView.image = [UIImage imageNamed:product.imageName];
  _heartView.hidden = !_product.rated;
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(rated))]) {
    
    _heartView.hidden = !_product.rated;
    
  }
  
}


@end
