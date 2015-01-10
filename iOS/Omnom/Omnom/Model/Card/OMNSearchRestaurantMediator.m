//
//  OMNSearchRestaurantMediator.m
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSearchRestaurantMediator.h"
#import "OMNSearchRestaurantsVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantListVC.h"
#import "OMNUserInfoVC.h"
#import "OMNScanTableQRCodeVC.h"
#import "OMNDemoRestaurantVC.h"
#import "OMNRestaurantCardVC.h"
#import "UINavigationController+omn_replace.h"

@interface OMNSearchRestaurantMediator ()
<OMNSearchRestaurantsVCDelegate,
OMNRestaurantActionsVCDelegate,
OMNScanTableQRCodeVCDelegate,
OMNUserInfoVCDelegate,
OMNDemoRestaurantVCDelegate>

@end

@implementation OMNSearchRestaurantMediator {
  
  __weak UIViewController *_demoPresentingVC;
  __weak UIViewController *_scanQRPresentingVC;
  
}

- (instancetype)initWithRootVC:(__weak UIViewController *)vc {
  self = [super init];
  if (self) {
    
    _rootVC = vc;
    
  }
  return self;
}

- (void)searchRestarants {
  
  OMNSearchRestaurantsVC *searchRestaurantsVC = [[OMNSearchRestaurantsVC alloc] initWithMediator:self];
  searchRestaurantsVC.delegate = self;
  [self.rootVC.navigationController pushViewController:searchRestaurantsVC animated:YES];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:nil];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = _rootVC.navigationController.delegate;
  [_rootVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)scanTableQrTap {
  
  _scanQRPresentingVC = _rootVC.navigationController.topViewController;
  OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
  scanTableQRCodeVC.delegate = self;
  [_rootVC.navigationController pushViewController:scanTableQRCodeVC animated:YES];
  
}

- (void)showRestaurants:(NSArray *)restaurants {
  
  if (1 == restaurants.count) {
    
    OMNRestaurant *restaurant = [restaurants firstObject];
    [self showRestaurant:restaurant];
    
  }
  else {
    
    [self chooseRestaurantFromRestaurants:restaurants];
    
  }
  
}

- (void)showCardForRestaurant:(OMNRestaurant *)restaurant {
  
  OMNRestaurantCardVC *restaurantCardVC = [[OMNRestaurantCardVC alloc] initWithMediator:self restaurant:restaurant];
  __weak UIViewController *presentingVC = _rootVC.navigationController.topViewController;
  __weak typeof(self)weakSelf = self;
  restaurantCardVC.didCloseBlock = ^{
    
    [weakSelf.rootVC.navigationController popToViewController:presentingVC animated:YES];
    
  };
  [_rootVC.navigationController pushViewController:restaurantCardVC animated:YES];
  
}

- (void)showRestaurant:(OMNRestaurant *)restaurant {
  
  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
  restaurantActionsVC.delegate = self;
  [_rootVC.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

- (void)chooseRestaurantFromRestaurants:(NSArray *)restaurants {
  
  OMNRestaurantListVC *restaurantListVC = [[OMNRestaurantListVC alloc] initWithMediator:self];
  restaurantListVC.restaurants = restaurants;
  [_rootVC.navigationController pushViewController:restaurantListVC animated:YES];
  
}

- (void)didFinish {
  
  if (self.didFinishBlock) {
    
    self.didFinishBlock();
    
  }
  
}

- (void)demoModeTap {
  
  _demoPresentingVC = _rootVC.navigationController.topViewController;
  OMNDemoRestaurantVC *demoRestaurantVC = [[OMNDemoRestaurantVC alloc] initWithParent:nil];
  demoRestaurantVC.delegate = self;
  [_rootVC.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

#pragma mark - OMNSearchRestaurantsVCDelegate

- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC {
  
  [self didFinish];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self didFinish];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [_rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurant:restaurant];
  
}

- (void)scanTableQRCodeVCDidCancel:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {

  [_rootVC.navigationController popToViewController:_scanQRPresentingVC animated:YES];
  
}

- (void)scanTableQRCodeVCRequestDemoMode:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [self demoModeTap];
  
}

#pragma mark - OMNDemoRestaurantVCDelegate

- (void)demoRestaurantVCDidFail:(OMNDemoRestaurantVC *)demoRestaurantVC withError:(OMNError *)error {
  
  [_rootVC.navigationController popToViewController:_demoPresentingVC animated:YES];
  
}

- (void)demoRestaurantVCDidFinish:(OMNDemoRestaurantVC *)demoRestaurantVC {

  [_rootVC.navigationController popToViewController:_demoPresentingVC animated:YES];
  
}


@end
