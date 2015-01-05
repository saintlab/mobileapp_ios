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
#import "OMNVisitor+network.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantListVC.h"
#import "OMNRestaurantMediator.h"

@interface OMNSearchRestaurantVC ()
<OMNRestaurantActionsVCDelegate>

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
  
  __weak typeof(self)weakSelf = self;
  OMNLoadingCircleVC *loadingCircleVC = nil;
  if (self.visitor) {
    
    loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:nil];
    
  }
  else {
    
    OMNSearchRestaurantsVC *searchRestaurantsVC = [[OMNSearchRestaurantsVC alloc] initWithParent:nil completion:^(OMNSearchRestaurantsVC *searchBeaconVC, NSArray *restaurants) {
      
      [weakSelf didFindRestaurants:restaurants];
      
    } cancelBlock:nil];
    searchRestaurantsVC.qr = self.qr;
    loadingCircleVC = searchRestaurantsVC;
    
  }
  UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
  loadingCircleVC.circleBackground = circleBackground;
  loadingCircleVC.circleIcon = [UIImage imageNamed:@"logo_icon"];
  loadingCircleVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController omn_pushViewController:loadingCircleVC animated:YES completion:^{
    
      if (weakSelf.visitor) {
        [loadingCircleVC.loaderView startAnimating:10.0f];
        [weakSelf loadLogo];
      }
      
    }];

  });
  
  _loadingCircleVC = loadingCircleVC;
  
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

- (void)didFindVisitor:(OMNVisitor *)visitor {
  
//  [visitor newGuestWithCompletion:^{
//  } failure:^(NSError *error) {
//  }];
//  self.visitor = visitor;
//  [self loadLogo];

}

- (void)loadLogo {
  
  __weak typeof(self)weakSelf = self;
  __weak OMNLoadingCircleVC *loadingCircleVC = _loadingCircleVC;
  [self.visitor.restaurant.decoration loadLogo:^(UIImage *image) {

    if (image) {
      
      [weakSelf didLoadLogo];
      
    }
    else {
      
      [loadingCircleVC showRetryMessageWithError:nil retryBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
          [weakSelf loadLogo];
          
        });
        
      } cancelBlock:^{
        
        [weakSelf didFinish];
        
      }];
      
    }
    
  }];
  
}

- (void)didLoadLogo {
  
  __weak typeof(_loadingCircleVC)weakBeaconSearch = _loadingCircleVC;
  OMNRestaurantDecoration *decoration = self.visitor.restaurant.decoration;

  __weak typeof(self)weakSelf = self;
  [_loadingCircleVC setLogo:decoration.logo withColor:decoration.background_color completion:^{
    
    [decoration loadBackground:^(UIImage *image) {
      
      [weakBeaconSearch finishLoading:^{
        
        [weakSelf didLoadBackground];
        
      }];

    }];
    
  }];
  
}

- (void)didLoadBackground {
  
#warning 123
//  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithVisitor:self.visitor];
//  restaurantActionsVC.delegate = self;
//  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

- (void)didFinish {
  
  [self.delegate searchRestaurantVCDidFinish:self];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVC:(OMNRestaurantActionsVC *)restaurantVC didChangeVisitor:(OMNVisitor *)visitor {
  
  self.visitor = visitor;
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self didFinish];
  
}

@end
