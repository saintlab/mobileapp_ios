//
//  OMNCameraPermissionVC.m
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraPermissionHelpVC.h"
#import "OMNCameraPermission.h"

@implementation OMNCameraPermissionHelpVC

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)init {
  
  NSArray *pages =
  @[
    [OMNHelpPage pageWithText:NSLocalizedString(@"CAMERA_PERMISSION_HELP_TEXT", @"Разрешите доступ\nк Камере в настройках\nдля Omnom:") imageName:@"settings_camera"],
    ];
  
  self = [super initWithPages:pages];
  if (self) {
    self.showSettingsButton = YES;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];

}

- (void)didBecomeActive {
  
  if ([OMNCameraPermission didReceiveCameraPermission]) {
    
    [self.delegate cameraPermissionHelpVCDidReceivePermission:self];
    
  }
  
}

@end
