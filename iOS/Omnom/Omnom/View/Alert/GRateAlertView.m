//
//  GRateAlertView.m
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GRateAlertView.h"

@interface GRateAlertView ()
<UIAlertViewDelegate>

@end

@implementation GRateAlertView {
  dispatch_block_t _block;
}

- (instancetype)initWithBlock:(dispatch_block_t)block {
  self = [super initWithTitle:NSLocalizedString(@"Как вам в \"Тарас Бульба\"?", nil) message:NSLocalizedString(@"Оцените, чтобы и другие знали на что рассчитывать :)", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Оценить", nil) otherButtonTitles:nil];
  if (self) {
    _block = block;
  }
  return self;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if (_block) {
    _block();
  }
  
}

@end
