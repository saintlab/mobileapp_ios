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
#import "OMNConstants.h"
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"

@implementation OMNPreorderConfirmCell {
  
  OMNPreorderConfirmView *_preorderConfirmView;
  
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
  
  _preorderConfirmView = [OMNPreorderConfirmView omn_autolayoutView];
  [self.contentView addSubview:_preorderConfirmView];
  
  NSDictionary *views =
  @{
    @"preorderConfirmView" : _preorderConfirmView,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[preorderConfirmView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[preorderConfirmView]|" options:kNilOptions metrics:metrics views:views]];
  
  [_preorderConfirmView.priceButton addTarget:self action:@selector(priceTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)priceTap {
  
  [self.delegate preorderConfirmCellDidEdit:self];
  
}

- (void)setHidePrice:(BOOL)hidePrice {
  
  _preorderConfirmView.priceButton.selected = hidePrice;
  
}

- (void)setItem:(OMNPreorderConfirmCellItem *)item {
  
  _item = item;
  _preorderConfirmView.menuProduct = item.menuProduct;
  
}

@end

@implementation OMNPreorderConfirmView {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    _nameLabel = [UILabel omn_autolayoutView];
    _nameLabel.numberOfLines = 0;
    [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    _nameLabel.textColor = colorWithHexString(@"000000");
    _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
    [self addSubview:_nameLabel];
    
    _infoLabel = [UILabel omn_autolayoutView];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
    _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
    [self addSubview:_infoLabel];
    
    _priceButton = [UIButton omn_autolayoutView];
    [_priceButton setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    _priceButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f);
    [_priceButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
    _priceButton.titleLabel.font = FuturaLSFOmnomLERegular(15.0f);
    [_priceButton setBackgroundImage:[[UIImage imageNamed:@"rounded_button_light_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
    [_priceButton setTitle:@"" forState:UIControlStateSelected];
    [_priceButton setTitle:@"" forState:UIControlStateSelected|UIControlStateHighlighted];
    UIImage *selectedImage = [[UIImage imageNamed:@"blue_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
    [_priceButton setBackgroundImage:selectedImage forState:UIControlStateSelected|UIControlStateHighlighted];
    UIImage *checkImage = [[UIImage imageNamed:@"ic_in_wish_list_position"] omn_tintWithColor:[OMNStyler blueColor]];
    [_priceButton setImage:checkImage forState:UIControlStateSelected];
    [_priceButton setImage:[UIImage imageNamed:@"ic_in_wish_list_position"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self addSubview:_priceButton];
    
    NSDictionary *views =
    @{
      @"nameLabel" : _nameLabel,
      @"infoLabel" : _infoLabel,
      @"priceButton" : _priceButton,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : [OMNStyler styler].leftOffset,
      };
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-[priceButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-(leftOffset)-[infoLabel]-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]" options:kNilOptions metrics:metrics views:views]];
    
  }
  return self;
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue - CGRectGetWidth(_priceButton.frame);
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setMenuProduct:(OMNMenuProduct *)menuProduct {
  
  _menuProduct = menuProduct;
  _nameLabel.text = menuProduct.name;
  _infoLabel.text = _menuProduct.details.displayText;
  if (_menuProduct.quantity > 0.0) {

    NSString *priceText = [NSString stringWithFormat:@"%.f x %@", _menuProduct.quantity, [OMNUtils moneyStringFromKop:_menuProduct.price]];
    [_priceButton setTitle:priceText forState:UIControlStateNormal];

  }
  else {
    
    [_priceButton setTitle:[OMNUtils moneyStringFromKop:_menuProduct.price] forState:UIControlStateNormal];

  }
  
}

@end
