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
  OMNLoadingCircleVC *loadingCircleVC = nil;
  if (self.visitor) {
    
    loadingCircleVC = [[OMNLoadingCircleVC alloc] initWithParent:nil];
    
  }
  else {
    
    OMNSearchVisitorVC *searchVisitorVC = [[OMNSearchVisitorVC alloc] initWithParent:nil completion:^(OMNSearchVisitorVC *searchBeaconVC, OMNVisitor *visitor) {
      
      [weakSelf didFindVisitor:visitor];
      
    } cancelBlock:nil];
    searchVisitorVC.qr = self.qr;
    loadingCircleVC = searchVisitorVC;
    
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

- (void)didFindVisitor:(OMNVisitor *)visitor {
  
  [visitor newGuestWithCompletion:^{
  } failure:^(NSError *error) {
  }];
  self.visitor = visitor;
  [self loadLogo];

}

- (void)loadLogo {
  
  __weak typeof(self)weakSelf = self;
  __weak OMNLoadingCircleVC *loadingCircleVC = _loadingCircleVC;
  [self.visitor.restaurant.decoration loadLogo:^(UIImage *image) {

    if (image) {
      [weakSelf didLoadLogo];
    }
    else {
      [loadingCircleVC showRetryMessageWithBlock:^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
          [weakSelf loadLogo];
        });
        
      }];
    }
    
  }];
  
}

- (void)didLoadLogo {
  
  __weak typeof(_loadingCircleVC)weakBeaconSearch = _loadingCircleVC;
  OMNRestaurantDecoration *decoration = self.visitor.restaurant.decoration;

  __weak typeof(self)weakSelf = self;
  [_loadingCircleVC setLogo:decoration.logo withColor:decoration.background_color completion:^{
    
    [decoration loadBackgroundBlurred:YES completion:^(UIImage *image) {
      
      [weakBeaconSearch finishLoading:^{
        
        [weakSelf didLoadBackground];
        
      }];

    }];
    
  }];
  
}

- (void)didLoadBackground {
  
  OMNRestaurantActionsVC *restaurantActionsVC = [[OMNRestaurantActionsVC alloc] initWithVisitor:self.visitor];
  restaurantActionsVC.delegate = self;
  [self.navigationController pushViewController:restaurantActionsVC animated:YES];
  
}

#pragma mark - OMNRestaurantActionsVCDelegate

- (void)restaurantActionsVC:(OMNRestaurantActionsVC *)restaurantVC didChangeVisitor:(OMNVisitor *)visitor {
  
  self.visitor = visitor;
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)restaurantActionsVCDidFinish:(OMNRestaurantActionsVC *)restaurantVC {
  
  [self.delegate searchRestaurantVCDidFinish:self];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

@end
