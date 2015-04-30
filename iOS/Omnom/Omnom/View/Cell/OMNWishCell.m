//
//  OMNWishCell.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNWishCell {
  
  UILabel *_nameLabel;
  UILabel *_priceLabel;
  
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
  [_nameLabel setContentHuggingPriority:0 forAxis:UILayoutConstraintAxisHorizontal];
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [UILabel omn_autolayoutView];
  _priceLabel.textAlignment = NSTextAlignmentRight;
  [_priceLabel setContentCompressionResistancePriority:900 forAxis:UILayoutConstraintAxisHorizontal];
  _priceLabel.textColor = [OMNStyler greyColor];
  _priceLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_priceLabel];
  
  UIView *lineView = [UIView omn_autolayoutView];
  lineView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  [self.contentView addSubview:lineView];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceLabel" : _priceLabel,
    @"lineView" : lineView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    @"padding" : @(10.0f),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[nameLabel]-[priceLabel]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(padding@999)-[nameLabel]-(padding@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceLabel]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lineView(1)]" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset - CGRectGetWidth(_priceLabel.frame);
  _nameLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setItem:(OMNWishCellItem *)item {
  
  _item = item;
  OMNOrderItem *orderItem = item.orderItem;
  _nameLabel.text = orderItem.name;
  _priceLabel.text = [OMNUtils moneyStringFromKop:orderItem.price_total];
  
}

@end
