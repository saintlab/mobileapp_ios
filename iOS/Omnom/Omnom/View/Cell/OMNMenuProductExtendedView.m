//
//  OMNMenuProductDetailsView.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductExtendedView.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNMenuProductExtendedView {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UILabel *_descriptionLabel;
  UILabel *_compositionLabel;
  NSLayoutConstraint *_imageHeightConstraint;
  NSArray *_heightConstraints;
//  UILabel *_ingredientsLabel;
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.opaque = YES;
  self.backgroundColor = backgroundColor;
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.opaque = YES;
  _productIV.backgroundColor = backgroundColor;
  _productIV.contentMode = UIViewContentModeScaleAspectFit;
  _productIV.clipsToBounds = YES;
  [self addSubview:_productIV];
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.numberOfLines = 0;
  _nameLabel.opaque = YES;
  _nameLabel.backgroundColor = backgroundColor;
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.numberOfLines = 0;
  _infoLabel.opaque = YES;
  _infoLabel.backgroundColor = backgroundColor;
  _infoLabel.textAlignment = NSTextAlignmentCenter;
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self addSubview:_infoLabel];
  
  _priceButton = [OMNMenuProductPriceButton omn_autolayoutView];
  [self addSubview:_priceButton];
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  _descriptionLabel.opaque = YES;
  _descriptionLabel.backgroundColor = backgroundColor;
  _descriptionLabel.textAlignment = NSTextAlignmentCenter;
  _descriptionLabel.textColor = colorWithHexString(@"000000");
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.font = FuturaOSFOmnomRegular(15.0f);
  [self addSubview:_descriptionLabel];

  _compositionLabel = [UILabel omn_autolayoutView];
  _compositionLabel.opaque = YES;
  _compositionLabel.numberOfLines = 0;
  _compositionLabel.backgroundColor = backgroundColor;
  _compositionLabel.textAlignment = NSTextAlignmentCenter;
  _compositionLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _compositionLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self addSubview:_compositionLabel];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"compositionLabel" : _compositionLabel,
    @"descriptionLabel" : _descriptionLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[descriptionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[productIV]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[compositionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_productIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self addConstraint:_imageHeightConstraint];
  
  [self updateHeightConstraints];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self removeConstraints:_heightConstraints];
    
  }
  
  _imageHeightConstraint.constant = (_menuProduct.photo.length) ? (150.0f) : (0.0f);
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"descriptionLabel" : _descriptionLabel,
    @"compositionLabel" : _compositionLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"infoLabelOffset" : (_menuProduct.details.displayFullText.length) ? (@(20.0f)) : (@(0.0f)),
    @"compositionLabelOffset" : (_menuProduct.details.compositionText.length) ? (@(20.0f)) : (@(0.0f)),
    @"descriptionLabelOffset" : (_menuProduct.Description.length) ? (@(20.0f)) : (@(0.0f)),
    };
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[productIV]-(8)-[nameLabel]-(infoLabelOffset)-[infoLabel]-(20)-[priceButton]-(descriptionLabelOffset)-[descriptionLabel]-(compositionLabelOffset)-[compositionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:_heightConstraints];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _infoLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _compositionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _descriptionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  _menuProduct = menuProduct;
  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = (menuProduct.quantity > 0.0);
  _descriptionLabel.text = menuProduct.Description;
  _nameLabel.text = menuProduct.name;
  _infoLabel.text = [menuProduct.details displayFullText];
  _compositionLabel.text = [menuProduct.details compositionText];
  [_priceButton setTitle:[OMNUtils formattedMoneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  [self updateHeightConstraints];
  
}

@end
