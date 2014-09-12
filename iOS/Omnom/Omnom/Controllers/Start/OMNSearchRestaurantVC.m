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
  
  if (CGRectGetHeight([UIScreen mainScreen].bounds) <= 480.0f) {
    self.logoIconsIV.hidden = YES;
    _logoIV.hidden = YES;
    self.bgIV.image = [UIImage imageNamed:@"LaunchImage-700"];
  }
  
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
  if (self.visitor) {
    
    _loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:nil];
    
  }
  else {
    
    _loadingCircleVC = [[OMNSearchBeaconVC alloc] initWithParent:nil completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
      
      [weakSelf didFindVisitor:visitor];
      
    } cancelBlock:nil];

    UIImage *circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:colorWithHexString(@"d0021b")];
    _loadingCircleVC.circleBackground = circleBackground;

  }
  _loadingCircleVC.circleIcon = [UIImage imageNamed:@"logo_icon"];
  _loadingCircleVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    [self.navigationController omn_pushViewController:_loadingCircleVC animated:YES completion:^{
    
      if (weakSelf.visitor) {
        [weakSelf didFindVisitor:weakSelf.visitor];
      }
      
    }];

  });
  
}

- (void)didFindVisitor:(OMNVisitor *)visitor {
  
  if (nil == self.visitor) {
    [visitor newGuestWithCompletion:^{
    } failure:^(NSError *error) {
    }];
  }

  [[OMNAnalitics analitics] logEnterRestaurant:visitor];
  
  __weak typeof(self)weakSelf = self;
  [visitor.restaurant loadLogo:^(UIImage *image) {
    //TODO: handle error loading image
    [weakSelf didLoadLogoForVisitor:visitor];
    
  }];

}

- (void)didLoadLogoForVisitor:(OMNVisitor *)visitor {
  
  __weak typeof(_loadingCircleVC)weakBeaconSearch = _loadingCircleVC;
  UIImage *logo = visitor.restaurant.logo;
  UIColor *restaurantBackgroundColor = visitor.restaurant.background_color;
  __weak typeof(self)weakSelf = self;
  [_loadingCircleVC setLogo:logo withColor:restaurantBackgroundColor completion:^{
    
    [visitor.restaurant loadBackgroundBlurred:YES completion:^(UIImage *image) {
      
      [weakBeaconSearch finishLoading:^{
        
        [weakSelf didLoadBackgroundForVisitor:visitor];
        
      }];

    }];
    
  }];
  
}

- (void)didLoadBackgroundForVisitor:(OMNVisitor *)visitor {
  
  [self.delegate searchRestaurantVC:self didFindVisitor:visitor];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
