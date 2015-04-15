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
<TTTAttributedLabelDelegate>

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
  self.numberOfLines = 0;
  
  NSString *buttonText = kOMN_USER_DISCLAMER_ACTION_TEXT;
  NSString *text = [NSString stringWithFormat:kOMN_USER_DISCLAMER_FORMAT, buttonText];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  [attributedString setAttributes:
  @{
    NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    } range:NSMakeRange(0, text.length)];
  self.text = attributedString;

  self.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [OMNStyler linkColor],
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    };
  self.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : [OMNStyler activeLinkColor],
    NSFontAttributeName : FuturaOSFOmnomRegular(18.0f),
    };

  [self addLinkToURL:[NSURL URLWithString:@"http://legal.saintlab.com/omnom/user-agreement/"] withRange:[text rangeOfString:buttonText]];

}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  [[UIApplication sharedApplication] openURL:url];
}

@end
