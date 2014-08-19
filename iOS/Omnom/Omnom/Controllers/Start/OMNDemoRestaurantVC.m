//
//  OMNDemoRestaurantVC.m
//  omnom
//
//  Created by tea on 18.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoRestaurantVC.h"
#import "OMNDecodeBeaconManager.h"
#import "OMNR1VC.h"

@interface OMNDemoRestaurantVC ()
<OMNR1VCDelegate>

@end

@implementation OMNDemoRestaurantVC {
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    
    self.circleIcon = [UIImage imageNamed:@"logo_icon"];
    self.backgroundImage = [UIImage imageNamed:@"wood_bg"];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  __weak typeof(self)weakSelf = self;
  [[OMNDecodeBeaconManager manager] decodeBeacons:@[@{@"uuid" : @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0+A+1"}] success:^(NSArray *decodeBeacons) {
    
    OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
    [weakSelf didDecodeUUID:decodeBeacon];
    
  } failure:^(NSError *error) {
    
    [weakSelf didFailOmnom];
    
  }];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.loaderView startAnimating:10.0];
}

- (void)didFailOmnom {
  
  [self.delegate demoRestaurantVCDidFail:self];
  
}

- (void)didDecodeUUID:(OMNDecodeBeacon *)decodeBeacon {
  _decodeBeacon = decodeBeacon;
  __weak typeof(self)weakSelf = self;
  [_decodeBeacon.restaurant loadLogo:^(UIImage *image) {
    //TODO: handle error loading image
    [weakSelf didLoadLogo];
    
  }];
}

- (void)didLoadLogo {
  
  OMNRestaurant *restaurant = _decodeBeacon.restaurant;
  UIImage *logo = restaurant.logo;
  UIColor *restaurantBackgroundColor = restaurant.background_color;
  __weak typeof(self)weakSelf = self;
  [self setLogo:logo withColor:restaurantBackgroundColor completion:^{
    
    [restaurant loadBackground:^(UIImage *image) {
      
      [weakSelf finishLoading:^{
        
        [weakSelf didLoadBackground];
        
      }];
      
    }];
    
  }];
  
}

- (void)didLoadBackground {
  
  OMNR1VC *restaurantVC = [[OMNR1VC alloc] initWithDecodeBeacon:_decodeBeacon];
  restaurantVC.delegate = self;
  [self.navigationController pushViewController:restaurantVC animated:YES];
  
}

#pragma mark - OMNR1VCDelegate

- (void)r1VCDidFinish:(OMNR1VC *)r1VC {
  
  [self.delegate demoRestaurantVCDidFinish:self];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}


@end
