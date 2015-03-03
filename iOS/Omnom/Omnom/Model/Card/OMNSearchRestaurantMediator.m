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
#import "OMNNavigationControllerDelegate.h"
#import "OMNRestaurantOfflineVC.h"

@interface OMNSearchRestaurantMediator ()
<OMNSearchRestaurantsVCDelegate,
OMNScanTableQRCodeVCDelegate>

@end

@implementation OMNSearchRestaurantMediator {
  
  OMNRestaurantListVC *_restaurantListVC;
  
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
  __weak typeof(self)weakSelf = self;
  userInfoVC.didCloseBlock = ^{
    
    [weakSelf.rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
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

- (void)showRestaurantListVC {
  
  [_restaurantListVC.navigationController popToViewController:_restaurantListVC animated:YES];
  
}

- (void)showRestaurants:(NSArray *)restaurants {
  
  if (_restaurantListVC) {
    
    [_rootVC.navigationController popToViewController:_restaurantListVC animated:NO];
    
  }
  
  NSMutableArray *controllers = [NSMutableArray arrayWithArray:_rootVC.navigationController.viewControllers];
  
  if (!_restaurantListVC) {
    
    _restaurantListVC = [[OMNRestaurantListVC alloc] initWithMediator:self];
    [controllers addObject:_restaurantListVC];

  }
  
  __weak typeof(self)weakSelf = self;
  dispatch_block_t showRestaurantListBlock = ^{
    
    [weakSelf showRestaurantListVC];
    
  };
  
  if (1 == restaurants.count) {
    
    OMNRestaurant *restaurant = [restaurants firstObject];
    
    if (restaurant.hasTable ||
        restaurant.hasOrders) {
      
      OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
      restaurantActionsVC.didCloseBlock = showRestaurantListBlock;
      restaurantActionsVC.rescanTableBlock = ^{
        
        [weakSelf didFinish];
        
      };
      [controllers addObject:restaurantActionsVC];
      
    }
    else if (restaurant.available) {

      OMNRestaurantCardVC *restaurantCardVC = [[OMNRestaurantCardVC alloc] initWithMediator:self restaurant:restaurant];
      restaurantCardVC.didCloseBlock = showRestaurantListBlock;
      [controllers addObject:restaurantCardVC];
      
    }
    else {
      
      OMNRestaurantOfflineVC *restaurantOfflineVC = [[OMNRestaurantOfflineVC alloc] init];
      restaurantOfflineVC.completionBlock = showRestaurantListBlock;
      [controllers addObject:restaurantOfflineVC];
      
    }
    
  }
  else {
    
    _restaurantListVC.restaurants = restaurants;
    
  }
  
  [_rootVC.navigationController setViewControllers:controllers animated:YES];
  
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

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurants:@[restaurant]];
  
}

- (void)scanTableQRCodeVCRequestDemoMode:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [self demoModeTap];
  
}

@end
