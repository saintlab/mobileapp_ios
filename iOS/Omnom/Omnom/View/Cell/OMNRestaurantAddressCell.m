//
//  OMNRestaurantAddressCell.m
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressCell.h"
#import "UIView+omn_autolayout.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"

@implementation OMNRestaurantAddressCell {
  
  UILabel *_label;
  UILabel *_detailLabel;
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {

    self.contentView.opaque = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _label = [UILabel omn_autolayoutView];
    _label.opaque = YES;
    _label.backgroundColor = [UIColor whiteColor];
    _label.font = FuturaLSFOmnomLERegular(18.0f);
    _label.numberOfLines = 0;
    [self.contentView addSubview:_label];
    
    _detailLabel = [UILabel omn_autolayoutView];
    _detailLabel.opaque = YES;
    _detailLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
    _detailLabel.backgroundColor = [UIColor whiteColor];
    _detailLabel.font = FuturaLSFOmnomLERegular(18.0f);
    _detailLabel.numberOfLines = 0;
    [self.contentView addSubview:_detailLabel];
    
    self.accessoryView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"checkbox_white"] omn_tintWithColor:[OMNStyler blueColor]]];
    
    NSDictionary *views =
    @{
      @"contentView" : self.contentView,
      @"label" : _label,
      @"detailLabel" : _detailLabel,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : [[OMNStyler styler] leftOffset],
      };
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(5)-[label]-[detailLabel]-(5)-|" options:kNilOptions metrics:nil views:views]];
    self.separatorInset = UIEdgeInsetsMake(0.0f, [[[OMNStyler styler] leftOffset] floatValue], 0.0f, 0.0f);
    
  }
  return self;
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*[OMNStyler styler].leftOffset.floatValue - CGRectGetWidth(self.accessoryView.frame);
  _label.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _detailLabel.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setItem:(OMNRestaurantAddressCellItem *)item {
  
  _item = item;
  self.accessoryView.hidden = !item.selected;
  _label.text = item.address.name;
  _detailLabel.text = item.address.text;
  
}


@end
