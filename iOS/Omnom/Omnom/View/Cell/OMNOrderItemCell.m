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
  
  self.selectionStyle = UITableViewCellSelectionStyleBlue;
  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.backgroundColor = ([UIColor colorWithRed:2/255. green:193/255. blue:100/255. alpha:1]);
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _nameLabel.textColor = [style colorForKey:@"nameLabelColor"];
  _nameLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:18.0f];
  [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [[UILabel alloc] init];
  _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
  UIColor *priceLabelColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.8f];
  _priceLabel.textColor = priceLabelColor;
  _priceLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:17.0f];
  _priceLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_priceLabel];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceLabel" : _priceLabel,
      };
  
  NSDictionary *metrics =
  @{
    @"labelsOffset": @(12.0f),
    @"lowPriority":@(UILayoutPriorityDefaultLow)
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceLabel]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[nameLabel]-(labelsOffset)-[priceLabel]-|" options:0 metrics:metrics views:views]];
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  _iconView.image = orderItem.icon;
  
  NSMutableAttributedString *priceQuantityString = nil;
  NSString *priceString = [OMNUtils commaStringFromKop:orderItem.price_per_item];
  if (orderItem.quantity > 1) {
    priceQuantityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d x %@", orderItem.quantity, priceString]];
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
