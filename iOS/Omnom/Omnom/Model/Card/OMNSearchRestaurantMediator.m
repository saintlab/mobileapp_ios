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
OMNScanTableQRCodeVCDelegate,
OMNUserInfoVCDelegate>

@end

@implementation OMNSearchRestaurantMediator {
  
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
  
  OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
  scanTableQRCodeVC.delegate = self;
  __weak UIViewController *presentingVC = _rootVC.navigationController.topViewController;
  __weak typeof(self)weakSelf = self;
  scanTableQRCodeVC.didCloseBlock = ^{
    
    [weakSelf.rootVC.navigationController popToViewController:presentingVC animated:YES];
    
  };
  [_rootVC.navigationController pushViewController:scanTableQRCodeVC animated:YES];
  
}

- (void)showRestaurants:(NSArray *)restaurants {
  
  NSMutableArray *controllers = [NSMutableArray array];
  OMNRestaurantListVC *restaurantListVC = [[OMNRestaurantListVC alloc] initWithMediator:self];
  restaurantListVC.restaurants = restaurants;
  [controllers addObject:restaurantListVC];
  
  if (1 == restaurants.count) {
    
    OMNRestaurant *restaurant = [restaurants firstObject];
    OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
    __weak typeof(self)weakSelf = self;
    restaurantActionsVC.didCloseBlock = ^{

      [restaurantListVC.navigationController popToViewController:restaurantListVC animated:YES];
      
    };
    restaurantActionsVC.rescanTableBlock = ^{
      
      [weakSelf didFinish];
      
    };
    [controllers addObject:restaurantActionsVC];
    
  }
  
  [_rootVC.navigationController setViewControllers:[_rootVC.navigationController.viewControllers arrayByAddingObjectsFromArray:controllers] animated:YES];
  
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

- (void)didFinish {
  
  if (self.didFinishBlock) {
    
    self.didFinishBlock();
    
  }
  
}

- (void)demoModeTap {
  
  OMNDemoRestaurantVC *demoRestaurantVC = [[OMNDemoRestaurantVC alloc] initWithParent:nil];
  __weak typeof(self)weakSelf = self;
  __weak UIViewController *presentingVC = _rootVC.navigationController.topViewController;
  demoRestaurantVC.didCloseBlock = ^{
    
    [weakSelf.rootVC.navigationController popToViewController:presentingVC animated:YES];
    
  };
  [_rootVC.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

#pragma mark - OMNSearchRestaurantsVCDelegate

- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC {
  
  [self didFinish];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [_rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurants:@[restaurant]];
  
}

- (void)scanTableQRCodeVCRequestDemoMode:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [self demoModeTap];
  
}

@end