//
//  OMNMenuProductDetailsCell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductFullCell.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNMenuProductFullCell {
  
  UILabel *_infoLabel;
  UILabel *_descriptionLabel;
  UILabel *_compositionLabel;
  NSArray *_heightConstraints;
  
}

@synthesize priceButton = _priceButton;
@synthesize productIV = _productIV;
@synthesize item = _item;
@synthesize nameLabel = _nameLabel;

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.contentView.clipsToBounds = YES;
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.opaque = YES;
  self.backgroundColor = backgroundColor;
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.opaque = YES;
  _productIV.backgroundColor = backgroundColor;
  _productIV.contentMode = UIViewContentModeScaleAspectFill;
  _productIV.clipsToBounds = YES;
  [self.contentView addSubview:_productIV];
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.numberOfLines = 0;
  _nameLabel.backgroundColor = [UIColor clearColor];
  [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.numberOfLines = 0;
  _infoLabel.opaque = YES;
  _infoLabel.backgroundColor = backgroundColor;
  _infoLabel.textAlignment = NSTextAlignmentCenter;
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [_infoLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_infoLabel];
  
  _priceButton = [OMNMenuProductPriceButton omn_autolayoutView];
  [_priceButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [_priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:_priceButton];
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  _descriptionLabel.opaque = YES;
  _descriptionLabel.backgroundColor = backgroundColor;
  _descriptionLabel.textAlignment = NSTextAlignmentCenter;
  _descriptionLabel.textColor = colorWithHexString(@"000000");
  _descriptionLabel.numberOfLines = 0;
  _descriptionLabel.font = FuturaOSFOmnomRegular(15.0f);
  [_descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_descriptionLabel];
  
  _compositionLabel = [UILabel omn_autolayoutView];
  _compositionLabel.opaque = YES;
  _compositionLabel.numberOfLines = 0;
  _compositionLabel.backgroundColor = backgroundColor;
  _compositionLabel.textAlignment = NSTextAlignmentCenter;
  _compositionLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _compositionLabel.font = FuturaOSFOmnomRegular(12.0f);
  [_compositionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_compositionLabel];
  
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
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[descriptionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[productIV]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[compositionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setItem:(OMNMenuProductFullCellItem *)item {
  
  _item = item;
  OMNMenuProduct *menuProduct = item.menuProduct;
  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = menuProduct.preordered;
  _descriptionLabel.text = menuProduct.Description;
  _nameLabel.attributedText = menuProduct.nameAttributedString;
  _infoLabel.text = [menuProduct.details displayFullText];
  _compositionLabel.text = [menuProduct.details compositionText];
  [_priceButton setTitle:[OMNUtils moneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  [self updateHeightConstraints];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self.contentView removeConstraints:_heightConstraints];
    
  }
  
  OMNMenuProduct *menuProduct = self.item.menuProduct;
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"descriptionLabel" : _descriptionLabel,
    @"compositionLabel" : _compositionLabel,
    };
  
  CGFloat imageHeight = 0.0f;
  if (menuProduct.photoImage) {
    
    CGFloat aspect = CGRectGetWidth(self.frame) / menuProduct.photoImage.size.width;
    imageHeight = menuProduct.photoImage.size.height*aspect;
    
  }
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"imageHeight" : @(imageHeight),
    @"infoLabelOffset" : (menuProduct.details.displayFullText.length) ? (@(2.0f)) : (@(0.0f)),
    @"compositionLabelOffset" : (menuProduct.details.compositionText.length) ? (@(10.0f)) : (@(0.0f)),
    @"descriptionLabelOffset" : (menuProduct.Description.length) ? (@(10.0f)) : (@(0.0f)),
    };
  
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[productIV(imageHeight)]-(8)-[nameLabel]-(infoLabelOffset)-[infoLabel]-(10)-[priceButton]-(descriptionLabelOffset)-[descriptionLabel]-(compositionLabelOffset)-[compositionLabel]-(leftOffset@750)-|" options:kNilOptions metrics:metrics views:views];
  [self.contentView addConstraints:_heightConstraints];
  [self.contentView setNeedsUpdateConstraints];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _infoLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _compositionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _descriptionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

@end

