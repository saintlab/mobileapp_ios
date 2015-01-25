//
//  OMNMenuProductCell.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductCell.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import <BlocksKit.h>
#import "UIImage+omn_helper.h"

@implementation OMNMenuProductCell {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UIButton *_priceButton;
  UIImageView *_productIV;
  NSString *_productSelectionObserverID;
  NSString *_productImageObserverID;
  NSLayoutConstraint *_heightConstraint;
  
}

- (void)dealloc {
  
  [self removeMenuProductObservers];
  
}

- (void)removeMenuProductObservers {
  
  if (_productSelectionObserverID) {
    [_menuProduct bk_removeObserversWithIdentifier:_productSelectionObserverID];
  }
  if (_productImageObserverID) {
    [_menuProduct bk_removeObserversWithIdentifier:_productImageObserverID];
    
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

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  _nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue;
  
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.numberOfLines = 0;
  _nameLabel.textAlignment = NSTextAlignmentCenter;
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.textAlignment = NSTextAlignmentCenter;
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self.contentView addSubview:_infoLabel];
  
  _priceButton = [UIButton omn_autolayoutView];
  _priceButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
  [_priceButton setTitleColor:colorWithHexString(@"157EFB") forState:UIControlStateNormal];
  [_priceButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateHighlighted];
  [_priceButton setTitle:@"" forState:UIControlStateSelected];
  [_priceButton setTitle:@"" forState:UIControlStateSelected|UIControlStateHighlighted];
  
  [_priceButton setImage:[UIImage imageNamed:@"ic_in_wish_list_position"] forState:UIControlStateSelected];
  [_priceButton setImage:[UIImage imageNamed:@"ic_in_wish_list_position"] forState:UIControlStateSelected|UIControlStateHighlighted];
  _priceButton.titleLabel.font = FuturaLSFOmnomLERegular(15.0f);
  [_priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [_priceButton setBackgroundImage:[[UIImage imageNamed:@"rounded_button_light_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  UIImage *selectedImage = [[UIImage imageNamed:@"blue_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
  [_priceButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
  [_priceButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
  [_priceButton setBackgroundImage:[selectedImage omn_tintWithColor:[colorWithHexString(@"157EFB") colorWithAlphaComponent:0.5f]] forState:UIControlStateSelected|UIControlStateHighlighted];
  [self.contentView addSubview:_priceButton];
  
  _productIV = [UIImageView omn_autolayoutView];
  _productIV.opaque = YES;
  _productIV.contentMode = UIViewContentModeScaleAspectFit;
  _productIV.clipsToBounds = YES;
  [self.contentView addSubview:_productIV];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"productIV" : _productIV,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };

  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[productIV]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(8)-[nameLabel]-(8)-[productIV]-(>=0)-[infoLabel]-(8)-[priceButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  _heightConstraint = [NSLayoutConstraint constraintWithItem:_productIV attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:0.0f];
  [self.contentView addConstraint:_heightConstraint];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  [self removeMenuProductObservers];
  _menuProduct = menuProduct;
  
  _heightConstraint.constant = (_menuProduct.photo.length) ? (110.0f) : (0.0f);
  __weak UIButton *priceButton = _priceButton;
  _productSelectionObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {
   
    [UIView transitionWithView:priceButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      priceButton.selected = mp.selected;
      
    } completion:nil];
    
  }];
  
  __weak UIImageView *productIV = _productIV;
  _productImageObserverID = [_menuProduct bk_addObserverForKeyPath:NSStringFromSelector(@selector(photoImage)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuProduct *mp, NSDictionary *change) {

    NSLog(@"%d", [NSThread isMainThread]);
    [UIView transitionWithView:productIV duration:5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      productIV.image = mp.photoImage;
      
    } completion:nil];
    
  }];
  
  _productIV.image = _menuProduct.photoImage;
  _priceButton.selected = _menuProduct.selected;
  _nameLabel.text = _menuProduct.name;
  _infoLabel.text = [_menuProduct.details displayText];
  [_priceButton setTitle:[OMNUtils formattedMoneyStringFromKop:_menuProduct.price*100ll] forState:UIControlStateNormal];

  [_menuProduct loadImage];
  
}

- (void)priceTap {
  
  [self.delegate menuProductCell:self didSelectProduct:_menuProduct];
  
}

@end
