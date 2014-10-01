//
//  OMNDisclamerView.m
//  omnom
//
//  Created by tea on 02.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDisclamerView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"

@interface OMNDisclamerView ()
<UITextViewDelegate>

@end

@implementation OMNDisclamerView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self omn_setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self omn_setup];
}

- (void)omn_setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  self.delegate = self;
  
  NSString *buttonText = NSLocalizedString(@"Пользовательское соглашение", nil);
  NSString *text = [NSString stringWithFormat:@"%@\n%@", NSLocalizedString(@"Нажимая «Далее», вы принимаете", nil), buttonText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
  @{
    NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    } range:NSMakeRange(0, text.length)];
  
  [attributedString addAttribute:NSLinkAttributeName value:[NSURL URLWithString:@"http://legal.saintlab.com/omnom/user-agreement/"] range:[text rangeOfString:buttonText]];
  
  self.linkTextAttributes =
  @{
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    };
  self.attributedText = attributedString;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
  return YES;
}

@end
