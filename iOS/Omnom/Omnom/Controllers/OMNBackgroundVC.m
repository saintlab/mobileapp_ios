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
  

  if (self.buttonInfo.count) {
    
    [self updateActionBoard];
    self.bottomToolbar.hidden = NO;
    
  }
  
  self.bottomViewConstraint.constant = 0.0f;
  [self.view layoutIfNeeded];

  
}

- (void)updateActionBoard {
  [self addActionBoardIfNeeded];
  
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

  _bottomToolbar.hidden = (self.buttonInfo.count == 0);
  
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
  _backgroundImage = backgroundImage;
  _backgroundView.image = self.backgroundImage;
}

- (void)addActionBoardIfNeeded {
  
  if (_bottomToolbar) {
    return;
  }
  
  _bottomToolbar = [[UIToolbar alloc] init];
  _bottomToolbar.hidden = YES;
  _bottomToolbar.translatesAutoresizingMaskIntoConstraints = NO;
  [_bottomToolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
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

- (UIBarButtonItem *)buttonWithInfo:(OMNBarButtonInfo *)info {
  UIButton *button = [[OMNToolbarButton alloc] initWithImage:info.image title:info.title];
  [button bk_addEventHandler:^(id sender) {

    if (info.block) {
      info.block();
    }
  } forControlEvents:UIControlEventTouchUpInside];
  return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end


@implementation OMNBarButtonInfo

+ (OMNBarButtonInfo *)infoWithTitle:(NSString *)title image:(UIImage *)image block:(dispatch_block_t)block {
  OMNBarButtonInfo *info = [[OMNBarButtonInfo alloc] init];
  info.title = title;
  info.image = image;
  info.block = block;
  return info;
}

@end