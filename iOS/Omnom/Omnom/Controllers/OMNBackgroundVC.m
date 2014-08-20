//
//  OMNStopRootVC.m
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"
#import "OMNToolbarButton.h"
#import <BlocksKit+UIKit.h>

@interface OMNBackgroundVC ()

@end

@implementation OMNBackgroundVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  _backgroundView.contentMode = UIViewContentModeBottom;
  [self.view insertSubview:_backgroundView atIndex:0];
  
  if (self.backgroundImage) {
    _backgroundView.image = self.backgroundImage;
  }
  
  [self showActionBoard];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (self.buttonInfo.count) {
    self.bottomViewConstraint.constant = 0.0f;
  }
  
}

- (void)showActionBoard {
  [self addBottomButtons];
  
  NSArray *items = nil;
  
  UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
  
  if (self.buttonInfo.count == 1) {
    items =
    @[
      flex,
      [self buttonWithInfo:self.buttonInfo[0]],
      flex,
      ];
  }
  
  if (self.buttonInfo.count == 2) {
    items =
    @[
      [self buttonWithInfo:self.buttonInfo[0]],
      flex,
      [self buttonWithInfo:self.buttonInfo[1]],
      ];
  }
  
  self.bottomToolbar.items = items;
  
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
  _backgroundImage = backgroundImage;
  _backgroundView.image = self.backgroundImage;
}

- (void)addBottomButtons {
  
  _bottomToolbar = [[UIToolbar alloc] init];
  _bottomToolbar.translatesAutoresizingMaskIntoConstraints = NO;
  [_bottomToolbar setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionBottom barMetrics:UIBarMetricsDefault];
  _bottomToolbar.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_bottomToolbar];
  
  NSDictionary *views =
  @{
    @"bottomToolbar": _bottomToolbar,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomToolbar]|" options:0 metrics:nil views:views]];
  
  _bottomViewConstraint = [NSLayoutConstraint constraintWithItem:_bottomToolbar attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:50.0f];
  [self.view addConstraint:_bottomViewConstraint];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(==50)]" options:0 metrics:nil views:views]];
  
}

- (UIBarButtonItem *)buttonWithInfo:(NSDictionary *)info {
  UIButton *button = [[OMNToolbarButton alloc] init];
  [button setImage:[UIImage imageNamed:@"cancel_later_icon_small"] forState:UIControlStateNormal];
  [button bk_addEventHandler:^(id sender) {
    dispatch_block_t block = info[@"block"];
    if (block) {
      block();
    }
  } forControlEvents:UIControlEventTouchUpInside];
  [button setTitle:info[@"title"] forState:UIControlStateNormal];
  [button setImage:info[@"image"] forState:UIControlStateNormal];
  [button sizeToFit];
  return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
