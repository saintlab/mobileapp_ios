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
    
    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Позже", nil) image:nil block:^{
        
        @strongify(self)
        [self didFinish];
        
      }],
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Разрешить", nil) image:nil block:^{
        
        @strongify(self)
        [self requestPermissionTap];
        
      }]
      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)didFinish {
  
  if (self.completionBlock) {
    self.completionBlock();
  }
  
}

- (void)requestPermissionTap {
  
  @weakify(self)
  [[OMNAuthorization authorisation] requestPushNotifications:^(BOOL success) {
    
    @strongify(self)
    [self didFinish];
    
  }];
  
}

@end
