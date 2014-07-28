//
//  OMNSplashVC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantVC.h"
#import "UIImage+omn_helper.h"

@interface OMNSearchRestaurantVC ()

@end

@implementation OMNSearchRestaurantVC {
  OMNSearchBeaconVCBlock _searchBeaconVCBlock;
  OMNSearchBeaconVC *_searchBeaconVC;
}

- (instancetype)initWithBlock:(OMNSearchBeaconVCBlock)block {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
    _searchBeaconVCBlock = block;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.bgIV.image = [UIImage imageNamed:@"splash_bg"];
  
  CGRect frame = self.logoIconsIV.frame;
  frame.origin.y = floorf(self.view.frame.size.height*0.36f) - .5f;
  frame.origin.x += 6.0f;
  self.logoIconsIV.frame = frame;
  
  CGFloat scale = 1/2.6f;
  self.logoIV.center = CGPointMake(159.0f, self.logoIconsIV.center.y + 2.0f);
  self.logoIV.transform = CGAffineTransformMakeScale(scale, scale);
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  
  _searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
   
    [_searchBeaconVC setLogo:[UIImage imageNamed:@"ginza_logo"] withColor:[UIColor blackColor] completion:^{

      _searchBeaconVCBlock(decodeBeacon);
      
    }];
    
  } cancelBlock:nil];
  
  UIImage *backgroundImage =
  _searchBeaconVC.circleIcon = [UIImage imageNamed:@"loading_icon"];
  _searchBeaconVC.backgroundImage = [UIImage imageNamed:@"bg_table"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController pushViewController:_searchBeaconVC animated:YES];

  });
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
