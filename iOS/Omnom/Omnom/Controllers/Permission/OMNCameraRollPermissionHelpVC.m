//
//  OMNCameraRollPermissionHelpVC.m
//  omnom
//
//  Created by tea on 05.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraRollPermissionHelpVC.h"
#import "OMNCameraRollPermission.h"

@implementation OMNCameraRollPermissionHelpVC

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
  
  if ([OMNCameraRollPermission didReceiveCameraPermission]) {
    
    [self.delegate cameraRollPermissionHelpVCDidReceivePermission:self];
    
  }
  
}

@end
