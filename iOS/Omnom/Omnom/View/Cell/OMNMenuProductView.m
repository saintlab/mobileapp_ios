//
//  OMNMenuProductView.m
//  omnom
//
//  Created by tea on 26.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductView.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuProductView {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UILabel *_descriptionLabel;
  UIView *_descriptionView;
  NSLayoutConstraint *_imageHeightConstraint;
  NSLayoutConstraint *_descriptionHeightConstraint;
  NSArray *_heightConstraints;
  
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
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.opaque = YES;
  _nameLabel.backgroundColor = backgroundColor;
  _nameLabel.numberOfLines = 0;
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.opaque = YES;
  _infoLabel.backgroundColor = backgroundColor;
  _infoLabel.textAlignment = NSTextAlignmentCenter;
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self addSubview:_infoLabel];
  
  _priceButton = [OMNMenuProductPriceButton omn_autolayoutView];
  [self addSubview:_priceButton];
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.backgroundColor = backgroundColor;
  _productIV.opaque = YES;
  _productIV.contentMode = UIViewContentModeScaleAspectFill;
  _productIV.clipsToBounds = YES;
  [self addSubview:_productIV];
  
  _descriptionView = [UIView omn_autolayoutView];
  [self addSubview:_descriptionView];
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  [_descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  _descriptionLabel.opaque = YES;
  _descriptionLabel.backgroundColor = backgroundColor;
  _descriptionLabel.textAlignment = NSTextAlignmentCenter;
  _descriptionLabel.textColor = colorWithHexString(@"000000");
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.font = FuturaOSFOmnomRegular(15.0f);
  [_descriptionView addSubview:_descriptionLabel];
  
  UILabel *moreLabel = [UILabel omn_autolayoutView];
  moreLabel.opaque = YES;
  moreLabel.backgroundColor = backgroundColor;
  moreLabel.textAlignment = NSTextAlignmentCenter;
  moreLabel.textColor = [OMNStyler blueColor];
  [moreLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  moreLabel.numberOfLines = 0;
  moreLabel.font = FuturaOSFOmnomRegular(15.0f);
  moreLabel.text = NSLocalizedString(@"eще", @"eще");
  [_descriptionView addSubview:moreLabel];
  
  NSDictionary *views =
  @{
    @"descriptionView" : _descriptionView,
    @"descriptionLabel" : _descriptionLabel,
    @"moreLabel" : moreLabel,
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[descriptionLabel][moreLabel]|" options:kNilOptions metrics:metrics views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[descriptionLabel]|" options:kNilOptions metrics:metrics views:views]];
  [_descriptionView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[moreLabel]|" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_descriptionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-2*[OMNStyler styler].leftOffset.floatValue]];
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[productIV]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_productIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self addConstraint:_imageHeightConstraint];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _infoLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self removeConstraints:_heightConstraints];
    
  }
  
  _imageHeightConstraint.constant = (_menuProduct.photo.length) ? (110.0f) : (0.0f);
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"descriptionLabel" : _descriptionLabel,
    @"descriptionView" : _descriptionView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"imageOffset" : (_menuProduct.photo.length) ? (@(8.0f)) : (@(0.0f)),
    @"infoLabelOffset" : (_menuProduct.details.displayText.length) ? (@(8.0f)) : (@(0.0f)),
    @"descriptionLabelOffset" : (_menuProduct.Description.length) ? (@(10.0f)) : (@(0.0f)),
    @"descriptionViewHeight" : (_menuProduct.Description.length) ? (@(25.0f)) : (@(0.0f)),
    };
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[nameLabel]-(imageOffset)-[productIV]-(descriptionLabelOffset)-[descriptionView(<=descriptionViewHeight)]-(infoLabelOffset)-[infoLabel]-(8)-[priceButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:_heightConstraints];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  _menuProduct = menuProduct;
  
  _descriptionLabel.text = [menuProduct.Description stringByAppendingString:@"..."];
  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = (menuProduct.quantity > 0.0);
  _nameLabel.text = menuProduct.name;
  _infoLabel.text = [menuProduct.details displayText];
  [_priceButton setTitle:[OMNUtils formattedMoneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  [self updateHeightConstraints];
  
}

@end
