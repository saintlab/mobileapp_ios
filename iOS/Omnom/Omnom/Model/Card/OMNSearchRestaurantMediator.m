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
#import "OMNVisitorFactory.h"

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
  
  OMNSearchRestaurantsVC *searchRestaurantsVC = [[OMNSearchRestaurantsVC alloc] init];
  searchRestaurantsVC.delegate = self;
  [self.rootVC.navigationController pushViewController:searchRestaurantsVC animated:YES];
  
}

#pragma mark - OMNSearchRestaurantsVCDelegate

- (void)searchRestaurantsVC:(OMNSearchRestaurantsVC *)searchRestaurantsVC didFindRestaurants:(NSArray *)restaurants {
  
  [self showRestaurants:restaurants];
  
}

- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC {
  
  [self didFinish];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithMediator:nil];
  @weakify(self)
  userInfoVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [_rootVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)scanTableQrTap {
  
  OMNScanTableQRCodeVC *scanTableQRCodeVC = [[OMNScanTableQRCodeVC alloc] init];
  scanTableQRCodeVC.delegate = self;
  UIViewController *presentingVC = _rootVC.navigationController.topViewController;
  @weakify(self)
  scanTableQRCodeVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC.navigationController popToViewController:presentingVC animated:YES];
    
  };
  [_rootVC.navigationController pushViewController:scanTableQRCodeVC animated:YES];
  
}

- (void)showRestaurantListAnimated:(BOOL)animated {
  
  if (_restaurantListVC) {
    [_restaurantListVC.navigationController popToViewController:_restaurantListVC animated:animated];
  }
  
}

- (UIViewController *)restaurantActionsVCForVisitor:(OMNVisitor *)visitor {
  
  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithVisitor:visitor];
  @weakify(self)
  restaurantActionsVC.didCloseBlock = ^{
    
    @strongify(self)
    [self showRestaurantListAnimated:YES];
    
  };
  restaurantActionsVC.rescanTableBlock = ^{
    
    @strongify(self)
    [self didFinish];
    
  };
  return restaurantActionsVC;
  
}

- (void)showVisitor:(OMNVisitor *)visitor {
  
  [_rootVC.navigationController pushViewController:[self restaurantActionsVCForVisitor:visitor] animated:YES];
  
}

- (void)showRestaurants:(NSArray *)restaurants {
  
  [self showRestaurantListAnimated:NO];
  NSMutableArray *controllers = [NSMutableArray arrayWithArray:_rootVC.navigationController.viewControllers];
  
  if (!_restaurantListVC) {
    
    _restaurantListVC = [[OMNRestaurantListVC alloc] initWithMediator:self];
    [controllers addObject:_restaurantListVC];

  }
  
  @weakify(self)
  dispatch_block_t showRestaurantListBlock = ^{
    
    @strongify(self)
    [self showRestaurantListAnimated:YES];
    
  };
  
  if (1 == restaurants.count) {
    
    OMNRestaurant *restaurant = [restaurants firstObject];
    
    if (restaurant.canProcess) {
      
      [controllers addObject:[self restaurantActionsVCForVisitor:[OMNVisitorFactory visitorForRestaurant:restaurant]]];
      
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
  @weakify(self)
  UIViewController *presentingVC = _rootVC.navigationController.topViewController;
  demoRestaurantVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.rootVC.navigationController popToViewController:presentingVC animated:YES];
    
  };
  [_rootVC.navigationController pushViewController:demoRestaurantVC animated:YES];
  
}

#pragma mark - OMNScanTableQRCodeVCDelegate

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant {
  
  [self showRestaurants:@[restaurant]];
  
}

- (void)scanTableQRCodeVCRequestDemoMode:(OMNScanTableQRCodeVC *)scanTableQRCodeVC {
  
  [self demoModeTap];
  
}

@end
