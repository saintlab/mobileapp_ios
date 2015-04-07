//
//  OMNLunchPaymentDoneVC.m
//  omnom
//
//  Created by tea on 06.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchPaymentDoneVC.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNUtils.h"
#import "OMNConstants.h"
#import "UIView+omn_autolayout.h"
#import "NSString+omn_date.h"

@implementation OMNLunchPaymentDoneVC {
  
  UILabel *_orderDoneLabel;
  UILabel *_orderDoneLabel1;
  UILabel *_textLabel;
  UILabel *_orderMailLabel;
  UIImageView *_logoView;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  UIColor *titleColor = [OMNStyler greenColor];
  
  _logoView.image = [[UIImage imageNamed:@"bar_success"] omn_tintWithColor:titleColor];
  
  _orderDoneLabel.text = kOMN_PAYMENT_SUCCESS_TITLE1;
  _orderDoneLabel.font = FuturaOSFOmnomRegular(30.0f);
  _orderDoneLabel.textColor = titleColor;
  
  NSDateFormatter *df = [NSDateFormatter new];
  [df setDateFormat:kOMN_PAYMENT_SUCCESS_DATE_FORMAT];
  _orderDoneLabel1.text = [df stringFromDate:self.visitor.wish.createdDate];
  _orderDoneLabel1.font = FuturaLSFOmnomLERegular(20.0f);
  _orderDoneLabel1.textColor = titleColor;
  
  NSString *date = [NSString stringWithFormat:@"%@ %@", [self.visitor.delivery.date omn_localizedInWeekday], [self.visitor.delivery.date omn_localizedDate]];
  _textLabel.text = [NSString stringWithFormat:kOMN_LUNCH_DONE_FORMAT, self.visitor.restaurant.address.text, date];
  _textLabel.font = FuturaLSFOmnomLERegular(17.0f);
  _textLabel.textColor = colorWithHexString(@"515753");
  
  _orderMailLabel.text = kOMN_PAYMENT_SUCCESS_MAIL_TEXT;
  _orderMailLabel.font = FuturaLSFOmnomLERegular(20.0f);
  _orderMailLabel.textColor = colorWithHexString(@"515753");
  
}

- (void)omn_setup {
  
  _orderDoneLabel = [UILabel omn_autolayoutView];
  _orderDoneLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderDoneLabel];
  
  _orderDoneLabel1 = [UILabel omn_autolayoutView];
  _orderDoneLabel1.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_orderDoneLabel1];
  
  _textLabel = [UILabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  _textLabel.textAlignment = NSTextAlignmentCenter;
  [self.contentView addSubview:_textLabel];
  
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
    @"contentView" : self.contentView,
    @"logoView" : _logoView,
    @"orderDoneLabel" : _orderDoneLabel,
    @"orderDoneLabel1" : _orderDoneLabel1,
    @"textLabel" : _textLabel,
    @"dividerIV" : dividerIV,
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
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderDoneLabel1]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[orderMailLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[logoView]-(20)-[orderDoneLabel]-[orderDoneLabel1]-(labelOffset)-[textLabel]-(labelOffset)-[dividerIV]-(labelOffset)-[orderMailLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
