//
//  OMNBankCardCell.m
//  omnom
//
//  Created by tea on 01.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardCell.h"
#import "OMNBankCard.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@implementation OMNBankCardCell {
  UILabel *_label;
  UIImageView *_iconView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    [self omn_setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self omn_setup];
}

- (void)omn_setup {
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.font = FuturaLSFOmnomLERegular(15.0f);
  _label.textColor = [UIColor blackColor];
  [self.contentView addSubview:_label];

  _iconView = [[UIImageView alloc] init];
  _iconView.contentMode = UIViewContentModeCenter;
  _iconView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_iconView];
  
  
  NSDictionary *views =
  @{
    @"label" : _label,
    @"iconView" : _iconView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[label]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[iconView]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-[iconView]-|" options:0 metrics:metrics views:views]];
  
}

- (void)setBankCard:(OMNBankCard *)bankCard selected:(BOOL)selected {

  UIColor *masked_panColor = nil;
  UIColor *associationColor = nil;
  
  if (selected) {
    _iconView.image = [UIImage imageNamed:@"selected_card_icon_blue"];
    masked_panColor = colorWithHexString(@"4A90E2");
    associationColor = [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f];
  }
  else {
    masked_panColor = [UIColor blackColor];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    _iconView.image = nil;
  }

  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", bankCard.masked_pan, bankCard.association]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : masked_panColor} range:[attributedString.string rangeOfString:bankCard.masked_pan]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : associationColor} range:[attributedString.string rangeOfString:bankCard.association]];
  _label.attributedText = attributedString;
  
}


@end
