//
//  OMNPreorderTotalCell.m
//  omnom
//
//  Created by tea on 30.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderTotalCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUtils.h"

@implementation OMNPreorderTotalCell {
  
  UILabel *_nameLabel;
  
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
  
  _nameLabel = [UILabel omn_autolayoutView];
  _nameLabel.textAlignment = NSTextAlignmentRight;
  _nameLabel.textColor = colorWithHexString(@"000000");
  _nameLabel.font = PRICE_BUTTON_FONT;
  [self.contentView addSubview:_nameLabel];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"rightOffset" : @([OMNStyler styler].leftOffset.floatValue + [OMNStyler buttonEdgeInsets].right),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[nameLabel]-(rightOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setItem:(OMNPreorderTotalCellItem *)item {
  
  NSString *priceText = [OMNUtils formattedMoneyStringFromKop:item.total];
  NSString *text = [NSString stringWithFormat:kOMN_TOTAL_TEXT, priceText];
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomMedium(20.0f) textColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.8f] textAlignment:NSTextAlignmentRight]];
  [attributedText setAttributes:[OMNUtils textAttributesWithFont:PRICE_BUTTON_FONT textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentRight] range:[text rangeOfString:priceText]];
  _nameLabel.attributedText = attributedText;
  
}

@end
