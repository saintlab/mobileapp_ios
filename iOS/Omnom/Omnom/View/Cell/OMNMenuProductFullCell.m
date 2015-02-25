//
//  OMNMenuProductDetailsCell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductFullCell.h"
#import <BlocksKit.h>
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNMenuProductFullCell

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.contentView.clipsToBounds = YES;
  
  self.menuProductView = [OMNMenuProductFullView omn_autolayoutView];
  [self.menuProductView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [self.contentView addSubview:self.menuProductView];
  
  NSDictionary *views =
  @{
    @"menuProductDetailsView" : self.menuProductView,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuProductDetailsView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuProductDetailsView]" options:kNilOptions metrics:metrics views:views]];
  
}

@end

@implementation OMNMenuProductFullView {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UILabel *_descriptionLabel;
  UILabel *_compositionLabel;
  NSLayoutConstraint *_imageHeightConstraint;
  NSArray *_heightConstraints;
  
}

- (void)omn_setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.opaque = YES;
  self.backgroundColor = backgroundColor;
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.opaque = YES;
  _productIV.backgroundColor = backgroundColor;
  _productIV.contentMode = UIViewContentModeScaleAspectFill;
  [_productIV setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
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
  
  //  _imageHeightConstraint = [NSLayoutConstraint constraintWithItem:_productIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  //  [self addConstraint:_imageHeightConstraint];
  
  [self updateHeightConstraints];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self removeConstraints:_heightConstraints];
    
  }
  
  OMNMenuProduct *menuProduct = self.item.menuProduct;
  
  _imageHeightConstraint.constant = (menuProduct.hasPhoto) ? (150.0f) : (0.0f);
  
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
    @"infoLabelOffset" : (menuProduct.details.displayFullText.length) ? (@(2.0f)) : (@(0.0f)),
    @"compositionLabelOffset" : (menuProduct.details.compositionText.length) ? (@(10.0f)) : (@(0.0f)),
    @"descriptionLabelOffset" : (menuProduct.Description.length) ? (@(10.0f)) : (@(0.0f)),
    };
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[productIV]-(8)-[nameLabel]-(infoLabelOffset)-[infoLabel]-(10)-[priceButton]-(descriptionLabelOffset)-[descriptionLabel]-(compositionLabelOffset)-[compositionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views];
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

- (void)setItem:(OMNMenuProductFullCellItem *)item {
  
  _item = item;
  OMNMenuProduct *menuProduct = item.menuProduct;
  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = menuProduct.preordered;
  _descriptionLabel.text = menuProduct.Description;
  _nameLabel.text = menuProduct.name;
  _infoLabel.text = [menuProduct.details displayFullText];
  _compositionLabel.text = [menuProduct.details compositionText];
  [_priceButton setTitle:[OMNUtils formattedMoneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  [self updateHeightConstraints];
  
}

@end
