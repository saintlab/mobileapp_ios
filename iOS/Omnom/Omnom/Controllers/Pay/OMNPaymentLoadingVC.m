//
//  OMNPaymentLoadingVC.m
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentLoadingVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>

#define kPaymentLoadingDiration 20.0

@implementation OMNPaymentLoadingVC

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {

    self.circleIcon = [UIImage imageNamed:@"flying_credit_card_icon"];
    self.estimateAnimationDuration = kPaymentLoadingDiration;
    UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"000000")];
    self.circleBackground = circleBackground;
    
  }
  return self;
}

- (void)startLoading {
  
  [self.loaderView setLoaderColor:[UIColor colorWithWhite:0.0f alpha:0.1f]];
  [self.loaderView startAnimating:kPaymentLoadingDiration];
  
}

- (void)didFailWithError:(NSError *)error action:(dispatch_block_t)actionBlock {
  
  @weakify(self)
  [self finishLoading:^{
    
    @strongify(self)
    [self setText:error.localizedDescription];
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:kOMN_OK_BUTTON_TITLE image:nil block:actionBlock]
      ];
    [self updateActionBoard];
    [self.view layoutIfNeeded];
    
  }];
  
}

@end
