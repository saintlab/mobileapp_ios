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

@implementation OMNPreorderConfirmCell {
  
  UILabel *_nameLabel;
  UILabel *_infoLabel;
  UIButton *_priceButton;
  
}

- (void)awakeFromNib {

  [self omn_setup];
  
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.numberOfLines = 0;
  [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [self.contentView addSubview:_nameLabel];
  
  _infoLabel = [UILabel omn_autolayoutView];
  _infoLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f];
  _infoLabel.font = FuturaLSFOmnomLERegular(12.0f);
  [self.contentView addSubview:_infoLabel];
  
  _priceButton = [UIButton omn_autolayoutView];
  [_priceButton setTitleColor:colorWithHexString(@"157EFB") forState:UIControlStateNormal];
  _priceButton.titleLabel.font = FuturaLSFOmnomLERegular(15.0f);
  [_priceButton setBackgroundImage:[[UIImage imageNamed:@"rounded_button_light_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  
  [self.contentView addSubview:_priceButton];
  
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
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-[priceButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[nameLabel]-(>=5)-[infoLabel]-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[infoLabel]" options:kNilOptions metrics:metrics views:views]];
  
}

@end
