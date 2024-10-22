//
//  OMNOrderTotalView.m
//  omnom
//
//  Created by tea on 18.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTotalView.h"
#import "OMNUtils.h"
#import <OMNStyler.h>

@implementation OMNOrderTotalView {
  
  UILabel *_totalLabel;
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIImageView *endBillIV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
  endBillIV.translatesAutoresizingMaskIntoConstraints = NO;
  [endBillIV setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self addSubview:endBillIV];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  UIView *bgView = [[UIView alloc] init];
  bgView.backgroundColor = backgroundColor;
  bgView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:bgView];
  
  self.backgroundColor = [UIColor clearColor];
  
  _totalLabel = [[UILabel alloc] init];
  _totalLabel.translatesAutoresizingMaskIntoConstraints = NO;
  [bgView addSubview:_totalLabel];
  
  NSDictionary *views =
  @{
    @"bgView" : bgView,
    @"endBillIV" : endBillIV,
    @"totalLabel" : _totalLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"labelHeight" : @(24.0f),
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgView]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endBillIV]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgView]-(-0.5)-[endBillIV]|" options:kNilOptions metrics:metrics views:views]];
  
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[totalLabel]|" options:kNilOptions metrics:metrics views:views]];
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[totalLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  NSString *moneyText = [OMNUtils moneyStringFromKop:_order.totalAmount];
  NSString *text = [NSString stringWithFormat:kOMN_TOTAL_TEXT, moneyText];
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomMedium(17.0f) textColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.8f] textAlignment:NSTextAlignmentCenter]];
  
  [attributedText setAttributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(17.0f) textColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.8f] textAlignment:NSTextAlignmentCenter] range:[text rangeOfString:moneyText]];
  _totalLabel.attributedText = attributedText;
  
}

@end
