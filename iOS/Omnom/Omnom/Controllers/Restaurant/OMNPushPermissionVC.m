//
//  OMNPushPermissionVC.m
//  omnom
//
//  Created by tea on 03.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushPermissionVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNAuthorisation.h"
#import "OMNToolbarButton.h"

@interface OMNPushPermissionVC ()

@end

@implementation OMNPushPermissionVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.circleIcon = [UIImage imageNamed:@"allow_push_icon_big"];
    self.faded = YES;
    self.text = NSLocalizedString(@"Разрешить Omnom получить push-уведомления", nil);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addBottomButtons];
  [self configureBottomButtons];
  self.bottomViewConstraint.constant = 0.0f;
}

- (void)configureBottomButtons {
  
  UIButton *leftButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"Позже", nil)];
  [leftButton addTarget:self action:@selector(didFinish) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *rightButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"Разрешить", nil)];
  [rightButton addTarget:self action:@selector(requestPermissionTap) forControlEvents:UIControlEventTouchUpInside];
  
  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:leftButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:rightButton],
    ];
  
}

- (void)didFinish {
  _completionBlock();
}

- (void)requestPermissionTap {
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] requestPushNotifications:^(BOOL success) {
    
    [weakSelf didFinish];
    
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
