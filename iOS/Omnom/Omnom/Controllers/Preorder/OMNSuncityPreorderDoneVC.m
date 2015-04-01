//
//  OMNSuncityPreorderDoneVC.m
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSuncityPreorderDoneVC.h"
#import "OMNUtils.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@interface OMNSuncityPreorderDoneVC ()
<TTTAttributedLabelDelegate>

@end

@implementation OMNSuncityPreorderDoneVC {
  OMNWish *_wish;
}

- (instancetype)initWithWish:(OMNWish *)wish didCloseBlock:(dispatch_block_t)didCloseBlock {
  self = [super init];
  if (self) {
    self.didCloseBlock = didCloseBlock;
    _wish = wish;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.textLabel.text = kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_1;
  
  UIColor *textColor = [colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.5f];
  
  NSString *text = [NSString stringWithFormat:kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_TEXT_2, [OMNUtils formattedMoneyStringFromKop:_wish.totalAmount], kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_ACTION_TEXT_2];
  NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(17.0f) textColor:textColor textAlignment:NSTextAlignmentCenter]];
  
  self.detailedTextLabel.linkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : textColor,
    NSFontAttributeName : FuturaOSFOmnomRegular(17.0f),
    };
  self.detailedTextLabel.activeLinkAttributes =
  @{
    (__bridge NSString *)kCTUnderlineStyleAttributeName : @(YES),
    NSForegroundColorAttributeName : colorWithHexString(@"FFFFFF"),
    NSFontAttributeName : FuturaOSFOmnomRegular(17.0f),
    };
  
  self.detailedTextLabel.text = attributedText;
  self.detailedTextLabel.delegate = self;
  [self.detailedTextLabel addLinkToURL:[NSURL URLWithString:@""] withRange:[text rangeOfString:kOMN_PREORDER_DONE_2GIS_SUNCITY_LABEL_ACTION_TEXT_2]];
  
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://tinkoff.ru/cardtocard/"]];
}

@end
