//
//  OMNCardEnterErrorView.m
//  omnom
//
//  Created by tea on 04.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardEnterErrorLabel.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUtils.h"

@implementation OMNCardEnterErrorLabel

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.numberOfLines = 0;
    self.linkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSForegroundColorAttributeName : [OMNStyler linkColor],
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    self.activeLinkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSForegroundColorAttributeName : [OMNStyler activeLinkColor],
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    self.inactiveLinkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    
    self.textColor = [OMNStyler redColor];
    self.font = FuturaOSFOmnomRegular(15.0f);
    
  }
  return self;
}

- (void)setWrongAmountError {
  
  NSString *text = [NSString stringWithFormat:@"%@ %@", kOMN_CARD_CONFIRM_WRONG_ENTER_AMOUNT_ERROR, kOMN_CARD_CONFIRM_NO_SMS_ACTION_TEXT];
  self.text = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(15.0f) textColor:[OMNStyler redColor] textAlignment:NSTextAlignmentCenter]];
  [self addLinkToURL:kOMNNoSMSURL withRange:[text rangeOfString:kOMN_CARD_CONFIRM_NO_SMS_ACTION_TEXT]];
  
}

- (void)setErrorText:(NSString *)text {
  
  if (text.length) {
    
    self.text = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(15.0f) textColor:[OMNStyler redColor] textAlignment:NSTextAlignmentCenter]];

  }
  else {
    
    self.text = nil;

  }
  
}

- (void)setUnknownError {
  [self setErrorText:kOMN_CARD_CONFIRM_OTHER_ERROR];
}

- (void)setHelpText {
 
  NSString *text = [NSString stringWithFormat:kOMN_CARD_CONFIRM_HINT_LABEL_FORMAT, kOMN_CARD_CONFIRM_MONEY_ACTION_TEXT, kOMN_CARD_CONFIRM_NO_SMS_ACTION_TEXT];
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(15.0f) textColor:[OMNStyler greyColor] textAlignment:NSTextAlignmentLeft]];
  self.text = attributedString;
  [self addLinkToURL:kOMNMoneyQuestionURL withRange:[text rangeOfString:kOMN_CARD_CONFIRM_MONEY_ACTION_TEXT]];
  [self addLinkToURL:kOMNNoSMSURL withRange:[text rangeOfString:kOMN_CARD_CONFIRM_NO_SMS_ACTION_TEXT]];
  
}

@end
