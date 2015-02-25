//
//  OMNPushPermissionVC.m
//  omnom
//
//  Created by tea on 03.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushPermissionVC.h"
#import "OMNAuthorization.h"

@interface OMNPushPermissionVC ()

@end

@implementation OMNPushPermissionVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.circleIcon = [UIImage imageNamed:@"allow_push_icon_big"];
    self.faded = YES;
    self.text = NSLocalizedString(@"Разрешить Omnom получить push-уведомления", nil);
    
    __weak typeof(self)weakSelf = self;
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Позже", nil) image:nil block:^{
        
        [weakSelf didFinish];
        
      }],
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Разрешить", nil) image:nil block:^{
        
        [weakSelf requestPermissionTap];
        
      }]
      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didFinish {
  
  _completionBlock();
  
}

- (void)requestPermissionTap {
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorization authorisation] requestPushNotifications:^(BOOL success) {
    
    [weakSelf didFinish];
    
  }];
  
}

@end
