//
//  OMNSplashVC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLogoVC.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNLaunchHandler.h"
#import "OMNNavigationController.h"

@implementation OMNLogoVC

- (instancetype)init {
  self = [super initWithNibName:@"OMNLogoVC" bundle:nil];
  if (self) {
    
    _searchRestaurantMediator = [[OMNSearchRestaurantMediator alloc] initWithRootVC:self];
    
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

- (PMKPromise *)present:(UIViewController *)rootVC {
  
  UINavigationController *navigationController = [OMNNavigationController controllerWithRootVC:self];
  navigationController.navigationBar.barStyle = UIBarStyleDefault;
  navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [rootVC presentViewController:navigationController animated:YES completion:^{
      fulfill(nil);
    }];
    
  }];

}

@end
