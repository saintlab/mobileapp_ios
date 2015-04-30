//
//  OMNPreorderConfirmCell.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderConfirmCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@implementation OMNPreorderConfirmCell {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UIButton *_priceButton;
  UIButton *_selectedPriceButton;
  
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
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.numberOfLines = 0;
  [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.textAlignment = NSTextAlignmentCenter;
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self.contentView addSubview:_infoLabel];
  
  _priceButton = [UIButton omn_autolayoutView];
  [_priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [_priceButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  _priceButton.contentEdgeInsets = [OMNStyler buttonEdgeInsets];
  [_priceButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
  [_priceButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateHighlighted];
  [_priceButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateSelected];
  [_priceButton setTitleColor:[colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.5f] forState:UIControlStateSelected|UIControlStateHighlighted];
  _priceButton.titleLabel.font = PRICE_BUTTON_FONT;
  UIImage *selectedBGImage = [[UIImage imageNamed:@"blue_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
  UIImage *bgImage = [[UIImage imageNamed:@"rounded_button_light_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
  [_priceButton setBackgroundImage:bgImage forState:UIControlStateNormal];
  [_priceButton setBackgroundImage:selectedBGImage forState:UIControlStateHighlighted];
  [_priceButton setBackgroundImage:selectedBGImage forState:UIControlStateSelected];
  [_priceButton setBackgroundImage:selectedBGImage forState:UIControlStateSelected|UIControlStateHighlighted];
  [self.contentView addSubview:_priceButton];
  
  _selectedPriceButton = [UIButton omn_autolayoutView];
  [_selectedPriceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  [_selectedPriceButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  _selectedPriceButton.contentEdgeInsets = [OMNStyler buttonEdgeInsets];
  [_selectedPriceButton setBackgroundImage:bgImage forState:UIControlStateNormal];
  [_selectedPriceButton setBackgroundImage:selectedBGImage forState:UIControlStateHighlighted];
  UIImage *checkImage = [[UIImage imageNamed:@"ic_in_wish_list_position"] omn_tintWithColor:[OMNStyler blueColor]];
  [_selectedPriceButton setImage:checkImage forState:UIControlStateNormal];
  [_selectedPriceButton setImage:[UIImage imageNamed:@"ic_in_wish_list_position"] forState:UIControlStateHighlighted];
  [self.contentView addSubview:_selectedPriceButton];
  
  UIView *lineView = [UIView omn_autolayoutView];
  lineView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  [self.contentView addSubview:lineView];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"infoLabel" : _infoLabel,
    @"priceButton" : _priceButton,
    @"selectedPriceButton" : _selectedPriceButton,
    @"lineView" : lineView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_selectedPriceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[selectedPriceButton(>=60)]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[nameLabel]-[priceButton(>=60)]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-(leftOffset@999)-[infoLabel]-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[infoLabel]" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lineView(1)]" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset - CGRectGetWidth(_priceButton.frame);
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)priceTap {
  
  if (!self.isEditing) {
    [_item.delegate preorderConfirmCellDidEdit:self];
  }
  
}

- (void)setItem:(OMNPreorderConfirmCellItem *)item {
  
  _item = item;
  OMNMenuProduct *menuProduct = item.menuProduct;
  _nameLabel.text = menuProduct.name;
  _infoLabel.text = menuProduct.details.weighVolumeText;
  [_priceButton setTitle:menuProduct.preorderedText forState:UIControlStateNormal];
  _priceButton.hidden = item.hidePrice;
  _priceButton.selected = menuProduct.preordered;
  _selectedPriceButton.hidden = !item.hidePrice;
  
}

@end

