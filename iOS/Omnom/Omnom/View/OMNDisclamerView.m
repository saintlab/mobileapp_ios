//
//  OMNDisclamerView.m
//  omnom
//
//  Created by tea on 02.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDisclamerView.h"
#import <OMNStyler.h>

@interface OMNDisclamerView ()
<UITextViewDelegate>

@end

@implementation OMNDisclamerView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  self.scrollEnabled = NO;
  self.editable = NO;
  self.textContainer.lineFragmentPadding = 0;
  self.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
  self.delegate = self;

  NSString *buttonText = NSLocalizedString(@"Пользовательского соглашения", nil);
  NSString *text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Нажимая Далее, вы выражаете согласие с условиями", nil), buttonText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  
  [attributedString setAttributes:
  @{
    NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:16.0f],
    NSLinkAttributeName : [NSURL URLWithString:@"http://legal.saintlab.com/omnom/user-agreement/"],
    }
                            range:[text rangeOfString:buttonText]];
  self.linkTextAttributes =
  @{
    NSForegroundColorAttributeName : colorWithHexString(@"4A90E2"),
    NSFontAttributeName : [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:16.0f],
    };
  self.attributedText = attributedString;

}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)url inRange:(NSRange)characterRange {
  return YES;
}

@end
