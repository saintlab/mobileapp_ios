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
    self.text = kOMN_CAMERA_ROLL_PERMISSION_DESCRIPTION_TEXT;
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
  
  if ([OMNCameraRollPermission didReceiveCameraPermission]) {
    
    [self.delegate cameraRollPermissionDescriptionVCDidReceivePermission:self];
    
  }
  
}

- (void)askPermissionTap {
  
  NSArray *pages =
  @[
    [OMNHelpPage pageWithText:kOMN_CAMERA_ROLL_PERMISSION_HELP_TEXT imageName:@"settings_photos"],
    ];
  
  OMNPermissionHelpVC *cameraPermissionHelpVC = [[OMNPermissionHelpVC alloc] initWithPages:pages];
  cameraPermissionHelpVC.showSettingsButton = YES;
  cameraPermissionHelpVC.didCloseBlock = self.didCloseBlock;
  [self.navigationController pushViewController:cameraPermissionHelpVC animated:YES];
  
}

@end
