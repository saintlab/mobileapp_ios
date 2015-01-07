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
#import <OMNStyler.h>
#import "OMNAnalitics.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantListVC.h"
#import "OMNRestaurantMediator.h"

@interface OMNSearchRestaurantVC ()
<OMNRestaurantActionsVCDelegate,
OMNSearchRestaurantsVCDelegate>

@end

@implementation OMNSearchRestaurantVC {

  OMNSearchRestaurantsVC *_searchRestaurantsVC;
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNSearchRestaurantVC" bundle:nil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.bgIV.image = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:colorWithHexString(@"CE1200")];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  _logoIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross-small-new"]];
  
  CGFloat iconsCenter = (IS_IPHONE_4_OR_LESS) ? (240.0f) : (284.0f);
  self.logoIconsIV.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, iconsCenter);
  
  _logoIV.center = CGPointMake(165.0f, self.logoIconsIV.center.y);
  [self.view addSubview:_logoIV];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  OMNSearchRestaurantsVC *searchRestaurantsVC = [[OMNSearchRestaurantsVC alloc] init];
  searchRestaurantsVC.delegate = self;
  searchRestaurantsVC.qr = self.qr;

  UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
  searchRestaurantsVC.circleBackground = circleBackground;
  searchRestaurantsVC.circleIcon = [UIImage imageNamed:@"logo_icon"];
  searchRestaurantsVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController pushViewController:searchRestaurantsVC animated:YES];

  });
  
  _searchRestaurantsVC = searchRestaurantsVC;
  
}

- (void)didFindRestaurants:(NSArray *)restaurants {
  
  if (1 == restaurants.count) {
    
    OMNRestaurant *restaurant = [restaurants firstObject];
    [self showRestaurant:restaurant];
    
  }
  else {
    
    [self chooseRestaurantFromRestaurants:restaurants];
    
  }
  
}

- (void)showRestaurant:(OMNRestaurant *)restaurant {
  
  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithRestaurant:restaurant];
  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

- (void)chooseRestaurantFromRestaurants:(NSArray *)restaurants {
  
  OMNRestaurantListVC *restaurantListVC = [[OMNRestaurantListVC alloc] init];
  restaurantListVC.restaurants = restaurants;
  [self.navigationController pushViewController:restaurantListVC animated:YES];
  
}

- (void)didFinish {
  
  [self.delegate searchRestaurantVCDidFinish:self];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self didFinish];
  
}

#pragma mark - OMNSearchRestaurantsVCDelegate

- (void)searchRestaurantsVC:(OMNSearchRestaurantsVC *)searchRestaurantsVC didFindRestaurants:(NSArray *)restaurants {
  
  [self didFindRestaurants:restaurants];
  
}

- (void)searchRestaurantsVCDidCancel:(OMNSearchRestaurantsVC *)searchRestaurantsVC {
  
  [self didFinish];
  
}

@end
