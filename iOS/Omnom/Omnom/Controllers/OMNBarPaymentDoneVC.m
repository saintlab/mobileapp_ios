//
//  OMNBarSuccessVC.m
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBarPaymentDoneVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import <TTTAttributedLabel.h>
#import "OMNUtils.h"
#import "UIImage+omn_helper.h"
#import "OMNLaunchHandler.h"

@interface OMNBarPaymentDoneVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNBarPaymentDoneVC {
  
  UILabel *_orderDoneLabel;
  UILabel *_orderNumberLabel;
  UILabel *_orderPinLabel;
  TTTAttributedLabel *_orderHelpLabel;
  UILabel *_orderMailLabel;
  UIImageView *_logoView;
  
  OMNWish *_wish;
  NSURL *_paymentOrdersURL;
  
}

- (instancetype)initWithWish:(OMNWish *)wish paymentOrdersURL:(NSURL *)paymentOrdersURL {
  self = [super init];
  if (self) {
    
    _wish = wish;
    _paymentOrdersURL = paymentOrdersURL;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  UIColor *titleColor = [OMNStyler greenColor];
  _logoView.image = [[UIImage imageNamed:@"bar_success"] omn_tintWithColor:titleColor];
  
  _orderDoneLabel.text = kOMN_PAYMENT_SUCCESS_TITLE1;
  _orderDoneLabel.font = FuturaOSFOmnomRegular(30.0f);
  _orderDoneLabel.textColor = titleColor;
  
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
  
  _orderHelpLabel.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : FuturaLSFOmnomLERegular(15.0f),
    };
  _orderHelpLabel.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaLSFOmnomLERegular(15.0f),
    };
  
  NSString *helpText = [NSString stringWithFormat:kOMN_BAR_SUCCESS_HELP_TEXT, kOMN_BAR_SUCCESS_HELP_ACTION_TEXT];
  _orderHelpLabel.text = [[NSAttributedString alloc] initWithString:helpText attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(15.0f) textColor:colorWithHexString(@"515753") textAlignment:NSTextAlignmentCenter]];
  [_orderHelpLabel addLinkToURL:_paymentOrdersURL withRange:[helpText rangeOfString:kOMN_BAR_SUCCESS_HELP_ACTION_TEXT]];
  _orderHelpLabel.delegate = self;
  
  _orderHelpLabel.font = FuturaOSFOmnomRegular(20.0f);
  _orderHelpLabel.textColor = colorWithHexString(@"000000");
  
  _orderMailLabel.text = kOMN_PAYMENT_SUCCESS_MAIL_TEXT;
  _orderMailLabel.font = FuturaLSFOmnomLERegular(20.0f);
  _orderMailLabel.textColor = colorWithHexString(@"515753");
  
}

- (void)omn_setup {
  
  _orderDoneLabel = [UILabel omn_autolayoutView];
  _orderDoneLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderDoneLabel];
  
  _orderNumberLabel = [UILabel omn_autolayoutView];
  _orderNumberLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderNumberLabel];
  
  _orderPinLabel = [UILabel omn_autolayoutView];
  _orderPinLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderPinLabel];
  
  _orderHelpLabel = [TTTAttributedLabel omn_autolayoutView];
  _orderHelpLabel.numberOfLines = 0;
  _orderHelpLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderHelpLabel];
  
  _orderMailLabel = [UILabel omn_autolayoutView];
  _orderMailLabel.numberOfLines = 0;
  _orderMailLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderMailLabel];
  
  _logoView = [UIImageView omn_autolayoutView];
  [self.contentView addSubview:_logoView];
  
  UIImageView *dividerIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"payment_divider"]];
  dividerIV.translatesAutoresizingMaskIntoConstraints = NO;
  [self.contentView addSubview:dividerIV];
  
  NSDictionary *views =
  @{
    @"logoView" : _logoView,
    @"dividerIV" : dividerIV,
    @"contentView" : self.contentView,
    @"orderDoneLabel" : _orderDoneLabel,
    @"orderNumberLabel" : _orderNumberLabel,
    @"orderPinLabel" : _orderPinLabel,
    @"orderHelpLabel" : _orderHelpLabel,
    @"orderMailLabel" : _orderMailLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"labelOffset" : @(10.0f),
    };

  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_logoView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:dividerIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderDoneLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderNumberLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderPinLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderHelpLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderMailLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoView]-(20)-[orderDoneLabel]-(labelOffset)-[orderNumberLabel]-(labelOffset)-[orderPinLabel]-(20)-[orderHelpLabel]-(labelOffset)-[dividerIV]-(labelOffset)-[orderMailLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  [[OMNLaunchHandler sharedHandler] openURL:url];
}

@end
