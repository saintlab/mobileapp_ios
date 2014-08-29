//
//  OMNOrderCell.m
//  restaurants
//
//  Created by tea on 29.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderCell.h"
#import "UIView+frame.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@implementation OMNOrderCell {
  UILabel *_nameLabel;
  UILabel *_priceLabel;
  
  UIImageView *_iconView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
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
  self.selectedBackgroundView.backgroundColor = kGreenColor;
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.textColor = [style colorForKey:@"nameLabelColor"];
  _nameLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:19.0f];
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [[UILabel alloc] init];
  _priceLabel.textColor = [style colorForKey:@"priceLabelColor"];
  _priceLabel.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:19.0f];
  _priceLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_priceLabel];
  
//  _iconView = [[UIImageView alloc] init];
//  _iconView.contentMode = UIViewContentModeCenter;
//  [self.contentView addSubview:_iconView];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  const CGFloat priceLabelWidth = 90.0f;
  const CGFloat labelsOffset = 12.0f;
  _iconView.frame = CGRectMake(0, 0, self.height, self.height);
  _priceLabel.frame = CGRectMake(self.width - priceLabelWidth - 15.0f, 0, priceLabelWidth, self.height);
  _nameLabel.frame = CGRectMake(_iconView.right + 8.0f, 0, self.width - _iconView.width - _priceLabel.width - labelsOffset, self.height);
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  _iconView.image = orderItem.icon;
  [self setTitle:orderItem.name subtitle:[OMNUtils moneyStringFromKop:100*orderItem.price]];
  
}

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
  _nameLabel.text = title;
  _priceLabel.text = subtitle;
  
}

@end
