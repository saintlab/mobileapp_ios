//
//  OMNWishPinView.m
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishPinView.h"
#import "OMNUtils.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"

@implementation OMNWishPinView {

  UILabel *_orderPinLabel;
  UILabel *_orderNumberLabel;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _orderNumberLabel = [UILabel omn_autolayoutView];
    _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderNumberLabel];
    
    _orderPinLabel = [UILabel omn_autolayoutView];
    _orderPinLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_orderPinLabel];
    
    NSDictionary *views =
    @{
      @"orderNumberLabel" : _orderNumberLabel,
      @"orderPinLabel" : _orderPinLabel,
      };
    
    NSDictionary *metrics =
    @{
      @"labelOffset" : @(OMNStyler.leftOffset)
      };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[orderNumberLabel]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[orderPinLabel]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[orderNumberLabel]-[orderPinLabel]|" options:kNilOptions metrics:metrics views:views]];
  
  }
  return self;
}

- (void)setWish:(OMNWish *)wish {
  
  _wish = wish;
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(16.0f) textColor:colorWithHexString(@"515753") textAlignment:NSTextAlignmentCenter];
  NSMutableAttributedString *numberText = [[NSMutableAttributedString alloc] initWithString:kOMN_BAR_SUCCESS_ORDER_NUMBER_TEXT attributes:[attributes copy]];
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(25.0f);
  NSString *number = [NSString stringWithFormat:@" %@", _wish.orderNumber];
  [numberText appendAttributedString:[[NSAttributedString alloc] initWithString:number attributes:[attributes copy]]];
  _orderNumberLabel.attributedText = numberText;
  
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(16.0f);
  NSMutableAttributedString *pinText = [[NSMutableAttributedString alloc] initWithString:kOMN_BAR_SUCCESS_PIN_TEXT attributes:[attributes copy]];
  attributes[NSFontAttributeName] = FuturaLSFOmnomLERegular(25.0f);
  NSString *pin = [NSString stringWithFormat:@" %@", _wish.pin];
  [pinText appendAttributedString:[[NSAttributedString alloc] initWithString:pin attributes:[attributes copy]]];
  _orderPinLabel.attributedText = pinText;
  
}

@end
