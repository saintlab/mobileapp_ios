//
//  OMNCardEnterErrorView.m
//  omnom
//
//  Created by tea on 04.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardEnterErrorView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@interface OMNCardEnterErrorView ()
<UITextViewDelegate>

@end

@implementation OMNCardEnterErrorView

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.linkTextAttributes =
    @{
      NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
      NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
      };
    
  }
  return self;
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
  
  [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@""] range:[text rangeOfString:actionText]];

  self.attributedText = attributedString;
  self.userInteractionEnabled = YES;

}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  super.attributedText = attributedText;
  self.textAlignment = NSTextAlignmentCenter;
}

- (void)setErrorText:(NSString *)text {
  
  if (0 == text.length) {
    self.attributedText = nil;
    return;
  }
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : colorWithHexString(@"D0021B"),
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, attributedString.length)];
  self.attributedText = attributedString;
  self.userInteractionEnabled = NO;

}

- (void)setUnknownError {
  
  [self setErrorText:NSLocalizedString(@"CARD_CONFIRM_OTHER_ERROR", @"Что-то пошло не так.\nПовторите попытку")];

}

- (void)setHelpText {
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"CARD_CONFIRM_HINT_LABEL_TEXT", @"Для привязки карты вам нужно подтвердить, что вы её владелец. Мы списали с вашей карты секретную сумму (до 50 руб.), о чём вам должна прийти SMS от банка. Посмотрите в сообщении, сколько списано и укажите сумму в поле выше.")];
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : colorWithHexString(@"000000"),
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:NSMakeRange(0, attributedString.length)];
  self.attributedText = attributedString;
  self.userInteractionEnabled = NO;
  
}

@end
