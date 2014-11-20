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

@implementation OMNPaymentLoadingVC

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {

    self.circleIcon = [UIImage imageNamed:@"flying_credit_card_icon"];
    self.estimateAnimationDuration = 15.0;
    UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"000000")];
    self.circleBackground = circleBackground;
    
  }
  return self;
}

- (void)startLoading {
  
  [self.loaderView setLoaderColor:[UIColor colorWithWhite:0.0f alpha:0.1f]];
  [self.loaderView startAnimating:15.0];
  
}

- (void)didFailWithError:(NSError *)error action:(dispatch_block_t)actionBlock {
  
  __weak typeof(self)weakSelf = self;
  [self finishLoading:^{
    
    [weakSelf setText:error.localizedDescription];
    weakSelf.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:actionBlock]
      ];
    [weakSelf updateActionBoard];
    [weakSelf.view layoutIfNeeded];
    
  }];
  
}

@end
