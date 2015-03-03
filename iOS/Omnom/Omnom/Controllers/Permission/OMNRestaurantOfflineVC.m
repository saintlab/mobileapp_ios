//
//  OMNRestaurantOfflineVC.m
//  omnom
//
//  Created by tea on 02.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantOfflineVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNError.h"

@implementation OMNRestaurantOfflineVC

- (instancetype)init {
  self = [super initWithParent:nil];
  if (self) {
    
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    self.text = [OMNError omnomErrorFromCode:kOMNErrorRestaurantUnavaliable].localizedDescription;
    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ok", nil) image:nil block:^{
        
        @strongify(self)
        [self didFinish];
        
      }],
      ];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"000000")];;
  self.circleIcon = [[UIImage imageNamed:@"error_icon_big"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
  self.circleButton.tintColor = [UIColor whiteColor];
  
}

- (void)didFinish {
  
  if (self.completionBlock) {
    self.completionBlock();
  }
  
}

@end
