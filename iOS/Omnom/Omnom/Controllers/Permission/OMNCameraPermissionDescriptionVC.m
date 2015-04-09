//
//  OMNCameraPermissionDescriptionVC.m
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraPermissionDescriptionVC.h"
#import "OMNCameraPermission.h"
#import "OMNPermissionHelpVC.h"

@implementation OMNCameraPermissionDescriptionVC

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {
    
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.circleIcon = [UIImage imageNamed:@"photo_icon_big"];

    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:kOMN_ALLOW_BUTTON_TITLE image:nil block:^{
        
        @strongify(self)
        [self askPermissionTap];
        
      }]
      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
  
}

- (void)didBecomeActive {
  
  if ([OMNCameraPermission didReceiveCameraPermission]) {
    
    [self.delegate cameraPermissionDescriptionVCDidReceivePermission:self];
    
  }
  
}

- (void)askPermissionTap {
  
  NSArray *pages =
  @[
    [OMNHelpPage pageWithText:NSLocalizedString(@"CAMERA_PERMISSION_HELP_TEXT", @"Разрешите доступ\nк Камере в настройках\nдля Omnom:") imageName:@"settings_camera"],
    ];
  
  OMNPermissionHelpVC *cameraPermissionHelpVC = [[OMNPermissionHelpVC alloc] initWithPages:pages];
  cameraPermissionHelpVC.showSettingsButton = YES;
  cameraPermissionHelpVC.didCloseBlock = self.didCloseBlock;
  [self.navigationController pushViewController:cameraPermissionHelpVC animated:YES];
  
}

@end
