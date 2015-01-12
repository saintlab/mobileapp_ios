//
//  OMNDenyCLPermissionVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDenyCLPermissionVC.h"

@interface OMNDenyCLPermissionVC ()

@end

@implementation OMNDenyCLPermissionVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.text = NSLocalizedString(@"Ваше разрешение на геолокацию – одно из необходимых условий работы Omnom. Без этого мы не сможем.", nil);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.circleBackground = nil;
  self.circleIcon = [[UIImage imageNamed:@"allow_geolocation_icon_big"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.circleButton.tintColor = [UIColor blackColor];
  
}

@end
