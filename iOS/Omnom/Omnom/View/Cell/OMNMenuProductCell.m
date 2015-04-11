//
//  OMNMenuProductCell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCell.h"
#import <BlocksKit.h>
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@implementation OMNMenuProductCell {
  
  NSString *_productSelectionObserverID;
  NSString *_productImageObserverID;
  NSString *_productEditingObserverID;
  
  UILabel *_descriptionLabel;
  NSArray *_heightConstraints;
  UIView *_delimiterView;
  
}

- (void)dealloc {
  
  [self removeMenuProductObservers];
  
}

- (void)removeMenuProductObservers {
  
  if (_productSelectionObserverID) {
    [self.item.menuProduct bk_removeObserversWithIdentifier:_productSelectionObserverID];
  }
  if (_productImageObserverID) {
    [self.item.menuProduct bk_removeObserversWithIdentifier:_productImageObserverID];
  }
  if (_productEditingObserverID) {
    [self.item.menuProduct bk_removeObserversWithIdentifier:_productEditingObserverID];
  }
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.contentView.clipsToBounds = YES;
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.opaque = YES;
  self.backgroundColor = backgroundColor;
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.backgroundColor = [UIColor clearColor];
  _nameLabel.numberOfLines = 0;
  [_nameLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_nameLabel];
  
  _priceButton = [OMNMenuProductPriceButton omn_autolayoutView];
  [_priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [_priceButton setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_priceButton];
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.backgroundColor = backgroundColor;
  _productIV.opaque = YES;
  _productIV.contentMode = UIViewContentModeScaleAspectFill;
  _productIV.clipsToBounds = YES;
  [self.contentView addSubview:_productIV];
  
  _descriptionLabel = [UILabel omn_autolayoutView];
  _descriptionLabel.opaque = YES;
  _descriptionLabel.backgroundColor = backgroundColor;
  _descriptionLabel.numberOfLines = 1;
  [_descriptionLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self.contentView addSubview:_descriptionLabel];
  
  _delimiterView = [UIView omn_autolayoutView];
  [self.contentView addSubview:_delimiterView];
  
  NSDictionary *views =
  @{
    @"descriptionLabel" : _descriptionLabel,
    @"nameLabel" : _nameLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"delimiterView" : _delimiterView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:80.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[descriptionLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[productIV]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[delimiterView]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _descriptionLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)addMenuProductObservers {
  
  @weakify(self)
  _productSelectionObserverID = [self.item.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(quantity)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
    
    @strongify(self)
    [UIView transitionWithView:self.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      self.priceButton.selected = mp.preordered;
      
    } completion:nil];
    
  }];
  
  _productEditingObserverID = [self.item bk_addObserverForKeyPath:NSStringFromSelector(@selector(editing)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProductCellItem *mp, NSDictionary *change) {
    
    @strongify(self)
    [UIView transitionWithView:self.priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      self.priceButton.omn_editing = mp.editing;
      
    } completion:nil];
    
  }];
  
  _productImageObserverID = [self.item.menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
    
    @strongify(self)
    [UIView transitionWithView:self.productIV duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      self.productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
}

- (void)setItem:(OMNMenuProductCellItem *)item {
  
  [self removeMenuProductObservers];
  _item = item;
  [self addMenuProductObservers];
  
  [_item.menuProduct loadImage];
  
  OMNMenuProduct *menuProduct = item.menuProduct;
  _descriptionLabel.attributedText = menuProduct.shortDescription;
  
  _productIV.image = menuProduct.photoImage;
  _priceButton.selected = menuProduct.preordered;
  _nameLabel.attributedText = menuProduct.nameAttributedString;
  
  [_priceButton setTitle:[OMNUtils moneyStringFromKop:menuProduct.price] forState:UIControlStateNormal];
  _delimiterView.backgroundColor = (kBottomDelimiterTypeNone == item.delimiterType) ? ([UIColor clearColor]) : ([UIColor colorWithWhite:0.0f alpha:0.3f]);
  
  [self updateHeightConstraints];
  
}

- (void)updateHeightConstraints {
  
  if (_heightConstraints) {
    
    [self.contentView removeConstraints:_heightConstraints];
    
  }
  
  BOOL hasPhoto = _item.menuProduct.hasPhoto;
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    @"descriptionLabel" : _descriptionLabel,
    @"delimiterView" : _delimiterView,
    };
  
  OMNMenuProduct *menuProduct = _item.menuProduct;
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"imageOffset" : (hasPhoto) ? @(8.0f) : @(0.0f),
    @"imageHeight" : (hasPhoto) ? @(110.0f) : @(0.0f),
    @"descriptionLabelOffset" : (menuProduct.shortDescription.length) ? @(10.0f) : @(0.0f),
    };
  
  _heightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[nameLabel]-(imageOffset)-[productIV(imageHeight)]-(descriptionLabelOffset)-[descriptionLabel]-(8)-[priceButton]-(leftOffset@999)-[delimiterView(1)]|" options:kNilOptions metrics:metrics views:views];
  [self.contentView addConstraints:_heightConstraints];

}

- (void)priceTap {
  [self.item.delegate menuProductCellDidEdit:self];
}

@end

