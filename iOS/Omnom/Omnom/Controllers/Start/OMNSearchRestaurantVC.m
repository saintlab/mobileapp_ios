//
//  OMNSplashVC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSearchRestaurantVC.h"
#import "UIImage+omn_helper.h"
#import <AFHTTPRequestOperation.h>
#import "UINavigationController+omn_replace.h"

@interface OMNSearchRestaurantVC ()

@end

@implementation OMNSearchRestaurantVC {

  OMNLoadingCircleVC *_loadingCircleVC;
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  self.logoIconsIV.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 287.0f);

  _logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross-small-new"]];
  _logoIV.center = CGPointMake(165.0f, self.logoIconsIV.center.y);
  [self.view addSubview:_logoIV];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  if (self.decodeBeacon) {
    
    _loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:nil];
    
  }
  else {
    
    _loadingCircleVC = [[OMNSearchBeaconVC alloc] initWithParent:nil completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
      
      [weakSelf didFindBeacon:decodeBeacon];
      
    } cancelBlock:nil];

  }
  _loadingCircleVC.circleIcon = [UIImage imageNamed:@"logo_icon"];
  _loadingCircleVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController omn_pushViewController:_loadingCircleVC animated:YES completion:^{
    
      if (weakSelf.decodeBeacon) {
        [weakSelf didFindBeacon:weakSelf.decodeBeacon];
      }
      
    }];

  });
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  if (nil == self.decodeBeacon) {
    [decodeBeacon.restaurant newGuestForTableID:decodeBeacon.table_id completion:^{
    } failure:^(NSError *error) {
    }];
  }
  
  __weak typeof(self)weakSelf = self;
  [decodeBeacon.restaurant loadLogo:^(UIImage *image) {
    //TODO: handle error loading image
    [weakSelf didLoadLogoForRestaurant:decodeBeacon];
    
  }];

}

- (void)didLoadLogoForRestaurant:(OMNDecodeBeacon *)decodeBeacon {
  
  __weak typeof(_loadingCircleVC)weakBeaconSearch = _loadingCircleVC;
  UIImage *logo = decodeBeacon.restaurant.logo;
  UIColor *restaurantBackgroundColor = decodeBeacon.restaurant.background_color;
  __weak typeof(self)weakSelf = self;
  [_loadingCircleVC setLogo:logo withColor:restaurantBackgroundColor completion:^{
    
    [decodeBeacon.restaurant loadBackground:^(UIImage *image) {
      
      [weakBeaconSearch finishLoading:^{
        
        [weakSelf didLoadBackgroundForRestaurant:decodeBeacon];
        
      }];

    }];
    
  }];
  
}

- (void)didLoadBackgroundForRestaurant:(OMNDecodeBeacon *)decodeBeacon {
  
  [self.delegate searchRestaurantVC:self didFindBeacon:decodeBeacon];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
