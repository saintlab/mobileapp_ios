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
  
  self.selectionStyle = UITableViewCellSelectionStyleBlue;
  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.backgroundColor = kGreenColor;
  
  _nameLabel = [[UILabel alloc] init];
  _nameLabel.textColor = [UIColor blackColor];
  _nameLabel.font = ALSRublFont(15.0f);
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [[UILabel alloc] init];
  _priceLabel.textColor = [UIColor colorWithWhite:127 / 255. alpha:1];
  _priceLabel.textAlignment = NSTextAlignmentRight;
  _priceLabel.font = ALSRublFont(15.0f);
  [self.contentView addSubview:_priceLabel];
  
  _iconView = [[UIImageView alloc] init];
  _iconView.contentMode = UIViewContentModeCenter;
  [self.contentView addSubview:_iconView];
  
}

- (void)layoutSubviews {
  [super layoutSubviews];
  
  const CGFloat priceLabelWidth = 90.0f;
  
  _iconView.frame = CGRectMake(0, 0, self.height, self.height);
  _priceLabel.frame = CGRectMake(self.width - priceLabelWidth - 10.0f, 0, priceLabelWidth, self.height);
  _nameLabel.frame = CGRectMake(_iconView.right, 0, self.width - _iconView.width - _priceLabel.width, self.height);
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  _iconView.image = orderItem.icon;
  _priceLabel.text = [NSString stringWithFormat:@"%.0fi", orderItem.price];
  _nameLabel.text = orderItem.name;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
