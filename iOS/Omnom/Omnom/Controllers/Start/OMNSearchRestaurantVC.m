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

@interface OMNSearchRestaurantVC ()

@end

@implementation OMNSearchRestaurantVC {
  OMNSearchRestaurantBlock _searchRestaurantBlock;
  OMNSearchBeaconVC *_searchBeaconVC;
}

- (instancetype)initWithBlock:(OMNSearchRestaurantBlock)block {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
    _searchRestaurantBlock = block;
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
  _searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithParent:nil completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [weakSelf didFindBeacon:decodeBeacon];
    
  } cancelBlock:nil];
  _searchBeaconVC.circleIcon = [UIImage imageNamed:@"logo_icon"];
  _searchBeaconVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController pushViewController:_searchBeaconVC animated:YES];

  });
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  [decodeBeacon.restaurant newGuestForTableID:decodeBeacon.tableId completion:^{
    
    NSLog(@"newGuestForTableID>done");
    
  } failure:^(NSError *error) {
    
    NSLog(@"newGuestForTableID>%@", error);
    
  }];
  
  __weak typeof(self)weakSelf = self;
  __weak typeof(_searchBeaconVC)weakBeaconSearch = _searchBeaconVC;
  [decodeBeacon.restaurant loadLogo:^(UIImage *image) {
    
    [weakSelf didLoadLogoForRestaurant:decodeBeacon.restaurant];
    if (image) {
      
    }
    else {
//      [weakBeaconSearch didFailOmnom];
    }
    
  }];

}

- (void)didLoadLogoForRestaurant:(OMNRestaurant *)restaurant {
  
  __weak typeof(_searchBeaconVC)weakBeaconSearch = _searchBeaconVC;
  OMNSearchRestaurantBlock searchRestaurantBlock = _searchRestaurantBlock;
  
  [_searchBeaconVC setLogo:restaurant.logo withColor:restaurant.background_color completion:^{
    
    [restaurant loadBackground:^(UIImage *image) {
      
      [weakBeaconSearch finishLoading:^{
        
        searchRestaurantBlock(restaurant);
        
      }];

    }];
    
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
