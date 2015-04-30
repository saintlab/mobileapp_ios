//
//  OMNQRHelpAlertVC.m
//  omnom
//
//  Created by tea on 08.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNQRHelpAlertVC.h"
#import <TTTAttributedLabel.h>
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNUtils.h"

@interface OMNQRHelpAlertVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNQRHelpAlertVC {
  
  TTTAttributedLabel *_textLabel;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self createViews];
  [self configureViews];
  
}

- (void)configureViews {
  
  NSMutableDictionary *attributes = [OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(15.0f) textColor:colorWithHexString(@"737478") textAlignment:NSTextAlignmentLeft];
  
  NSString *actionText = kOMN_QR_HOWTO_ACTION_TEXT;
  NSString *text = [NSString stringWithFormat:kOMN_QR_HOWTO_FORMAT, actionText];
  
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[attributes copy]];
  
  UIColor *linkColor = colorWithHexString(@"6BB4ED");
  attributes[(__bridge NSString *)kCTUnderlineStyleAttributeName] = @(YES);
  attributes[NSForegroundColorAttributeName] = linkColor;
  _textLabel.linkAttributes = [attributes copy];
  
  attributes[NSForegroundColorAttributeName] = [linkColor colorWithAlphaComponent:0.5];
  _textLabel.activeLinkAttributes = [attributes copy];
  
  _textLabel.text = attributedText;
  
  [_textLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
  
}

- (void)createViews {
  
  UIImageView *qrIV = [UIImageView omn_autolayoutView];
  qrIV.image = [UIImage imageNamed:@"qr-icon-small"];
  [self.contentView addSubview:qrIV];
  
  _textLabel = [TTTAttributedLabel omn_autolayoutView];
  _textLabel.delegate = self;
  _textLabel.numberOfLines = 0;
  [self.contentView addSubview:_textLabel];
  
  NSDictionary *views =
  @{
    @"qrIV" : qrIV,
    @"textLabel" : _textLabel,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[qrIV]-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:qrIV attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  
  if (self.didRequestDemoModeBlock) {
    
    self.didRequestDemoModeBlock();
    
  }
  
}

@end
