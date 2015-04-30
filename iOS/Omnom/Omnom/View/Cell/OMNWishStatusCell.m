//
//  OMNWishStatusCell.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishStatusCell.h"
#import "OMNWishPinView.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>

@implementation OMNWishStatusCell {
  
  UILabel *_label1;
  UILabel *_label2;
  OMNWishPinView *_pinView;
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  _label1 = [UILabel omn_autolayoutView];
  _label1.numberOfLines = 0;
  _label1.textColor = colorWithHexString(@"000000");
  _label1.textAlignment = NSTextAlignmentCenter;
  _label1.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_label1];
  
  _label2 = [UILabel omn_autolayoutView];
  _label2.numberOfLines = 0;
  _label2.textAlignment = NSTextAlignmentCenter;
  _label2.textColor = [OMNStyler greyColor];
  _label2.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_label2];
  
  _pinView = [OMNWishPinView omn_autolayoutView];
  [self.contentView addSubview:_pinView];
  
  NSDictionary *views =
  @{
    @"label1" : _label1,
    @"label2" : _label2,
    @"pinView" : _pinView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[label1]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset@999)-[label2]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pinView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label1]-[label2]-(leftOffset@999)-[pinView]-(leftOffset@999)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset;
  _label1.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  _label2.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setItem:(OMNWishStatusCellItem *)item {
  
  _item = item;
  OMNWish *wish = item.wish;
  _label1.attributedText = wish.statusText;
  _label2.text = wish.descriptionText;
  _pinView.wish = wish;
  
}

@end
