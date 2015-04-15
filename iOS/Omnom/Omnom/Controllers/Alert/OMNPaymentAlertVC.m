//
//  OMNPaymentAlertVC.m
//  omnom
//
//  Created by tea on 03.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentAlertVC.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIButton+omn_helper.h"
#import "OMNUtils.h"
#import "UIView+omn_autolayout.h"

@implementation OMNPaymentAlertVC {
  
  long long _amount;
  UILabel *_textLabel;
  UILabel *_detailedTextLabel;
  UIButton *_payButton;
  
}

- (instancetype)initWithAmount:(long long)amount {
  self = [super init];
  if (self) {

    _amount = amount;

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
  _payButton.titleLabel.font = PRICE_BUTTON_FONT;
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_payButton addTarget:self action:@selector(payTap) forControlEvents:UIControlEventTouchUpInside];
  [_payButton setTitle:[NSString stringWithFormat:kOMN_TO_PAY_BUTTON_FORMAT,  [OMNUtils formattedMoneyStringFromKop:_amount]] forState:UIControlStateNormal];

  _textLabel.text = kOMN_NO_SMS_ALERT_TEXT;
  _detailedTextLabel.text = kOMN_NO_SMS_ALERT_ACTION_TEXT;
  
}

- (UILabel *)textLabel {
  
  UILabel *textLabel = [UILabel omn_autolayoutView];
  textLabel.textColor = [OMNStyler greyColor];
  textLabel.opaque = YES;
  textLabel.numberOfLines = 0;
  textLabel.textAlignment = NSTextAlignmentCenter;
  textLabel.font = FuturaOSFOmnomRegular(15.0f);
  return textLabel;
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _textLabel = [self textLabel];
  _textLabel.backgroundColor = backgroundColor;
  [self.contentView addSubview:_textLabel];
  
  _detailedTextLabel = [self textLabel];
  _detailedTextLabel.backgroundColor = backgroundColor;
  _detailedTextLabel.hidden = YES;
  [self.contentView addSubview:_detailedTextLabel];
  
  _payButton = [UIButton omn_autolayoutView];
  _payButton.hidden = YES;
  [self.contentView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"detailedTextLabel" : _detailedTextLabel,
    @"payButton" : _payButton,
    @"contentView" : self.contentView,
    };
  
  CGFloat buttonSize = 44.0f;
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    @"buttonSize" : @(buttonSize),
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  if (_amount > 0ll) {

    _payButton.hidden = NO;
    _detailedTextLabel.hidden = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailedTextLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]-[detailedTextLabel]-20-[payButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  else {

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    
  }
  
}

- (void)payTap {
  
  if (self.didPayBlock) {
    
    self.didPayBlock();
    
  }
  
}

@end
