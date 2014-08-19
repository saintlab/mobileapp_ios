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
    self.faded = YES;
    self.text = NSLocalizedString(@"Ваше разрешение на геолокацию – одно из необходимых условий работы Omnom. Без этого мы не сможем определить столик.", nil);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.circleBackground = nil;
  self.circleIcon = [[UIImage imageNamed:@"allow_geolocation_icon_big"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.circleButton.tintColor = [UIColor blackColor];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
