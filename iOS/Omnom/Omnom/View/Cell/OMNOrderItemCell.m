//
//  OMNOrderCell.m
//  restaurants
//
//  Created by tea on 29.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItemCell.h"
#import "UIView+frame.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNOrderItemCell {
  UILabel *_nameLabel;
  UILabel *_priceLabel;
  
  UIImageView *_iconView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  OMNStyle *style = [[OMNStyler styler] styleForClass:self.class];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.contentView.opaque = YES;
  self.contentView.backgroundColor = backgroundColor;
  
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.layer.masksToBounds = YES;
  self.selectedBackgroundView.backgroundColor = ([UIColor colorWithRed:2/255. green:193/255. blue:100/255. alpha:1]);
  
  UIView *seporatorView = [[UIView alloc] init];
  seporatorView.translatesAutoresizingMaskIntoConstraints = NO;
  seporatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  [self.contentView addSubview:seporatorView];
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.opaque = YES;
  _nameLabel.backgroundColor = backgroundColor;
  _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _nameLabel.textColor = [style colorForKey:@"nameLabelColor"];
  _nameLabel.highlightedTextColor = [UIColor whiteColor];
  _nameLabel.font = FuturaLSFOmnomLERegular(18.0f);
  [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [[UILabel alloc] init];
  _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _priceLabel.opaque = YES;
  _priceLabel.backgroundColor = backgroundColor;
  UIColor *priceLabelColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.8f];
  _priceLabel.textColor = priceLabelColor;
  _priceLabel.font = FuturaLSFOmnomLERegular(17.0f);
  _priceLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_priceLabel];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceLabel" : _priceLabel,
    @"seporatorView" : seporatorView,
    };
  
  NSDictionary *metrics =
  @{
    @"labelsOffset" : @(12.0f),
    @"lowPriority" : @(UILayoutPriorityDefaultLow),
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel][seporatorView(1)]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceLabel]-1-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(labelsOffset)-[priceLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[seporatorView]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  _iconView.image = orderItem.icon;
  
  NSMutableAttributedString *priceQuantityString = nil;
  NSString *priceString = [OMNUtils commaStringFromKop:orderItem.price_per_item];
  if (orderItem.quantity > 1) {
    priceQuantityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld x %@", (long)orderItem.quantity, priceString]];
  }
  else {
    priceQuantityString = [[NSMutableAttributedString alloc] initWithString:priceString];
  }
  
  UIColor *priceColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  [priceQuantityString setAttributes:@{NSForegroundColorAttributeName : priceColor} range:[priceQuantityString.string rangeOfString:priceString]];
  
  _nameLabel.text = orderItem.name;
  _priceLabel.attributedText = priceQuantityString;
  
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
  _nameLabel.text = title;
  _priceLabel.text = subtitle;
  
}

@end
