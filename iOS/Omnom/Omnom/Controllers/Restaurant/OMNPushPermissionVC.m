//
//  OMNPushPermissionVC.m
//  omnom
//
//  Created by tea on 03.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPushPermissionVC.h"
#import "OMNAuthorization.h"

@implementation OMNPushPermissionVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.circleIcon = [UIImage imageNamed:@"allow_push_icon_big"];
    self.faded = YES;
#if OMN_TRAVELERS
    self.text = kOMN_PUSH_PERMISSION_TRAVELERS_DESCRIPTION_TEXT;
#else
    self.text = kOMN_PUSH_PERMISSION_DESCRIPTION_TEXT;
#endif
    
    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:kOMN_LATER_BUTTON_TITLE image:nil block:^{
        
        @strongify(self)
        [self didFinish];
        
      }],
      [OMNBarButtonInfo infoWithTitle:kOMN_ALLOW_BUTTON_TITLE image:nil block:^{
        
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
  [[OMNAuthorization authorization] requestPushNotifications:^(BOOL success) {
    
    @strongify(self)
    [self didFinish];
    
  }];
  
}

@end
