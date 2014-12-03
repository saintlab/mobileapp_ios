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

@implementation OMNCardEnterErrorLabel

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.numberOfLines = 0;
    self.linkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    self.activeLinkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSForegroundColorAttributeName : [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f],
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    self.inactiveLinkAttributes =
    @{
      (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    
    self.textColor = colorWithHexString(@"D0021B");
    self.font = FuturaOSFOmnomRegular(15.0f);
    
  }
  return self;
}

- (NSMutableParagraphStyle *)centerParagraphStyle {
  NSMutableParagraphStyle *attributeStyle = [[NSMutableParagraphStyle alloc] init];
  attributeStyle.alignment = NSTextAlignmentCenter;
  return attributeStyle;
}

- (void)setWrongAmountError {
  
  NSString *errorText = NSLocalizedString(@"CARD_CONFIRM_WRONG_ENTER_AMOUNT_ERROR", @"Введена неверная проверочная сумма. Загляните в последние SMS. Там должно быть сообщение от банка. Введите сумму из SMS.");
  NSString *actionText = NSLocalizedString(@"CARD_CONFIRM_NO_SMS_TEXT", @"Если SMS нет?");
  
  NSString *text = [NSString stringWithFormat:@"%@ %@", errorText, actionText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : colorWithHexString(@"D0021B"),
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:[text rangeOfString:errorText]];

  [attributedString setAttributes:
   @{
     NSParagraphStyleAttributeName : [self centerParagraphStyle],
     } range:NSMakeRange(0, text.length)];
  
  self.text = attributedString;
  [self addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:actionText]];
  
}

- (void)setText:(id)text {
  
  [super setText:text];
  self.textAlignment = NSTextAlignmentCenter;
  
}

- (void)setErrorText:(NSString *)text {
  
  if (0 == text.length) {
    self.text = nil;
    return;
  }
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
   @{
     NSParagraphStyleAttributeName : [self centerParagraphStyle],
     NSForegroundColorAttributeName : colorWithHexString(@"D0021B"),
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, attributedString.length)];
  self.text = attributedString;
  
}

- (void)setUnknownError {
  
  [self setErrorText:NSLocalizedString(@"CARD_CONFIRM_OTHER_ERROR", @"Что-то пошло не так.\nПовторите попытку")];
  
}

- (void)setHelpText {
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"CARD_CONFIRM_HINT_LABEL_TEXT", @"Для привязки карты вам нужно подтвердить, что вы её владелец. Мы списали с вашей карты секретную сумму (до 50 руб.), о чём вам должна прийти SMS от банка. Посмотрите в сообщении, сколько списано и укажите сумму в поле выше.")];
  [attributedString setAttributes:
   @{
     NSParagraphStyleAttributeName : [self centerParagraphStyle],
     NSForegroundColorAttributeName : colorWithHexString(@"000000"),
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, attributedString.length)];
  self.text = attributedString;
  
}

@end
