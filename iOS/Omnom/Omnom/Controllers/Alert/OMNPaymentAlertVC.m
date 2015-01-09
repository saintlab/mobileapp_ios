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

@interface OMNPaymentAlertVC ()

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailedText;

@end

@implementation OMNPaymentAlertVC {
  
  UIButton *_payButton;
  long long _amount;
  
}

- (instancetype)initWithText:(NSString *)text detailedText:(NSString *)detailedText amount:(long long)amount {
  self = [super init];
  if (self) {

    _amount = amount;
    self.text = text;
    self.detailedText = detailedText;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setup];
  
  _payButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_payButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_payButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_payButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_payButton addTarget:self action:@selector(payTap) forControlEvents:UIControlEventTouchUpInside];
  [_payButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"TO_PAY_BUTTON_TEXT %@", @"Оплатить {AMOUNT}"),  [OMNUtils formattedMoneyStringFromKop:_amount]] forState:UIControlStateNormal];
  
}

- (UILabel *)textLabel {
  
  UILabel *textLabel = [[UILabel alloc] init];
  textLabel.textColor = colorWithHexString(@"787878");
  textLabel.opaque = YES;
  textLabel.numberOfLines = 0;
  textLabel.textAlignment = NSTextAlignmentCenter;
  textLabel.font = FuturaOSFOmnomRegular(15.0f);
  textLabel.translatesAutoresizingMaskIntoConstraints = NO;
  return textLabel;
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  UILabel *textLabel = [self textLabel];
  textLabel.text = self.text;
  textLabel.backgroundColor = backgroundColor;
  [self.contentView addSubview:textLabel];
  
  UILabel *detailedTextLabel = [self textLabel];
  detailedTextLabel.text = self.detailedText;
  detailedTextLabel.backgroundColor = backgroundColor;
  [self.contentView addSubview:detailedTextLabel];
  
  _payButton = [[UIButton alloc] init];
  _payButton.hidden = YES;
  _payButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:_payButton];
  
  NSDictionary *views =
  @{
    @"textLabel" : textLabel,
    @"detailedTextLabel" : detailedTextLabel,
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
  
  if (_detailedText.length) {

    _payButton.hidden = NO;
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[detailedTextLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]-[detailedTextLabel]-20-[payButton]-(10)-|" options:kNilOptions metrics:metrics views:views]];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_payButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  else {

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textLabel]-|" options:kNilOptions metrics:metrics views:views]];
    
  }
  
}

- (void)payTap {
  
  if (self.didPayBlock) {
    
    self.didPayBlock();
    
  }
  
}

@end
