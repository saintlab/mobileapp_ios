//
//  OMNRatingProductCell.m
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRatingProductCell.h"
#import <BlocksKit.h>

@interface OMNRatingProductCell ()

@property (nonatomic, strong, readonly) UIImageView *heartView;

@end

@implementation OMNRatingProductCell {
  
  UIImageView *_heartView;
  NSString *_productRatedObserverID;
}

- (void)dealloc {
  [self omn_removeObservers];
}

- (void)omn_removeObservers {
  if (_productRatedObserverID) {
    [_product bk_removeObserversWithIdentifier:_productRatedObserverID];
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
  
  [self omn_removeObservers];
  _product = product;
  @weakify(self)
  [_product bk_addObserverForKeyPath:NSStringFromSelector(@selector(rated)) options:NSKeyValueObservingOptionNew task:^(OMNProduct *p, NSDictionary *change) {
    
    @strongify(self)
    self.heartView.hidden = !p.rated;
    
  }];
  
  _iconView.image = [UIImage imageNamed:product.imageName];
  _heartView.hidden = !_product.rated;
  
}

@end
