//
//  OMNCardEnterErrorView.h
//  omnom
//
//  Created by tea on 04.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <TTTAttributedLabel.h>

#define kOMNNoSMSURL ([NSURL URLWithString:@"no_sms_url"])
#define kOMNMoneyQuestionURL ([NSURL URLWithString:@"money_question_url"])

@interface OMNCardEnterErrorLabel : TTTAttributedLabel

- (void)setHelpText;
- (void)setWrongAmountError;
- (void)setErrorText:(NSString *)text;
- (void)setUnknownError;

@end
