//
//  OMNStartVC.m
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "UIImage+omn_helper.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNAuthorizationVC.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNR1VC.h"
#import "OMNDecodeBeaconManager.h"

@interface OMNStartVC ()
<OMNAuthorizationVCDelegate>

@end

@implementation OMNStartVC {
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  UINavigationController *_navVC;
  BOOL _tokenIsChecked;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _navigationControllerDelegate = [[OMNNavigationControllerDelegate alloc] init];
  
  self.navigationController.delegate = _navigationControllerDelegate;
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
  __weak typeof(self)weakSelf = self;
  [OMNAuthorisation authorisation].logoutCallback = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      
      [weakSelf requestAuthorization];
      
    }];
  };

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (NO == _tokenIsChecked) {
    [self checkToken];
  }
  
}

- (void)checkToken {
  _tokenIsChecked = YES;
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {
    
    if (tokenIsValid) {
      [weakSelf startSearchingBeacons];
    }
    else {
      [weakSelf requestAuthorization];
    }
    
  }];
}

- (void)startSearchingBeacons {
  
  __weak typeof(self)weakSelf = self;
  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    [weakSelf didFindRestaurant:decodeBeacon];
    
  }];
  
  NSData *decodeBeaconData = self.info[OMNDecodeBeaconManagerNotificationLaunchKey];
  if (decodeBeaconData) {
    OMNDecodeBeacon *decodeBeacon = [NSKeyedUnarchiver unarchiveObjectWithData:decodeBeaconData];
    searchRestaurantVC.decodeBeacon = decodeBeacon;
  }

  _navVC = [[UINavigationController alloc] initWithRootViewController:searchRestaurantVC];
  _navVC.delegate = _navigationControllerDelegate;
  [self presentViewController:_navVC animated:NO completion:nil];

}

- (void)requestAuthorization {
  OMNAuthorizationVC *authorizationVC = [[OMNAuthorizationVC alloc] init];
  authorizationVC.delegate = self;
  [self.navigationController pushViewController:authorizationVC animated:YES];
}

#pragma mark - OMNStartVC1Delegate

- (void)authorizationVCDidReceiveToken:(OMNAuthorizationVC *)startVC {
  
  [self.navigationController popToViewController:self animated:NO];
  __weak typeof(self)weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [weakSelf startSearchingBeacons];
  });
  
}

- (void)didFindRestaurant:(OMNDecodeBeacon *)decodeBeacon {
  
  OMNR1VC *restaurantMenuVC = [[OMNR1VC alloc] initWithDecodeBeacon:decodeBeacon];
  [_navVC pushViewController:restaurantMenuVC animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
