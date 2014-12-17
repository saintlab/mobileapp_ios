//
//  OMNCameraRollPermissionDescriptionVC.m
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraRollPermissionDescriptionVC.h"
#import "OMNPermissionHelpVC.h"
#import "OMNCameraRollPermission.h"

@interface OMNCameraRollPermissionDescriptionVC ()

@end

@implementation OMNCameraRollPermissionDescriptionVC

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {
    
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.text = NSLocalizedString(@"CAMERA_ROLL_PERMISSION_DESCRIPTION_TEXT", @"Для получения изображения\nнеобходимо разрешение на\nдоступ к камере.");
    self.circleIcon = [UIImage imageNamed:@"camera_icon_big"];
    
    __weak typeof(self)weakSelf = self;
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Разрешить", nil) image:nil block:^{
        
        [weakSelf askPermissionTap];
        
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
  
  if ([OMNCameraRollPermission didReceiveCameraPermission]) {
    
    [self.delegate cameraRollPermissionDescriptionVCDidReceivePermission:self];
    
  }
  
}

- (void)askPermissionTap {
  
  NSArray *pages =
  @[
    [OMNHelpPage pageWithText:NSLocalizedString(@"CAMERA_ROLL_PERMISSION_HELP_TEXT", @"Разрешите доступ\nк Фотографиям \nв настройках для Omnom:") imageName:@"settings_photos"],
    ];
  
  OMNPermissionHelpVC *cameraPermissionHelpVC = [[OMNPermissionHelpVC alloc] initWithPages:pages];
  cameraPermissionHelpVC.showSettingsButton = YES;
  cameraPermissionHelpVC.didCloseBlock = self.didCloseBlock;
  [self.navigationController pushViewController:cameraPermissionHelpVC animated:YES];
  
}

@end
