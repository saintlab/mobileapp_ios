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
#import "OMNAuthorization.h"
#import "OMNAuthorizationVC.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNNavigationController.h"
#import "OMNAnalitics.h"
#import "UINavigationController+omn_replace.h"
#import "OMNVisitorManager.h"
#import "NSURL+omn_query.h"

#warning OMNRestaurantsVC
#import "OMNRestaurantListVC.h"

@interface OMNStartVC ()
<OMNAuthorizationVCDelegate,
OMNSearchRestaurantVCDelegate>

@end

@implementation OMNStartVC {
  
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  BOOL _initialCheckPerformed;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _navigationControllerDelegate = [[OMNNavigationControllerDelegate alloc] init];
  
  self.navigationController.delegate = _navigationControllerDelegate;
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
  __weak typeof(self)weakSelf = self;
  [OMNAuthorization authorisation].logoutCallback = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      
      [weakSelf requestAuthorization];
      
    }];
  };

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self checkTokenIfNeeded];
  
}

- (void)checkTokenIfNeeded {
  
  if (_initialCheckPerformed) {
    return;
  }
  
  _initialCheckPerformed = YES;
  [self startSearchingRestaurant];

}

- (void)checkUserToken {
  
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{

    [[OMNAuthorization authorisation] checkUserWithBlock:^(OMNUser *user) {
      
      if (user) {
        
        [weakSelf startSearchingRestaurant];
        
      }
      else {
        
        [weakSelf requestAuthorization];
        
      }
      
    } failure:^(OMNError *error) {
      
      [weakSelf handleUserTokenError:error];
      
    }];
    
  }];
  
}

- (void)handleUserTokenError:(OMNError *)error {
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:nil];
  noInternetVC.text = error.localizedDescription;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf checkUserToken];
      
    }],
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Отменить", nil) image:nil block:^{
      
    }]
    ];
  [self.navigationController pushViewController:noInternetVC animated:YES];
  
}

- (void)startSearchingRestaurant {
  
  #warning OMNRestaurantsVC
//  OMNRestaurantListVC *restaurantsVC = [[OMNRestaurantListVC alloc] init];
//  UINavigationController *navC = [[OMNNavigationController alloc] initWithRootViewController:restaurantsVC];
//  navC.navigationBar.barStyle = UIBarStyleDefault;
//  navC.delegate = _navigationControllerDelegate;
//  [self presentViewController:navC animated:NO completion:nil];
//  return;

  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] init];
  searchRestaurantVC.delegate = self;
  
  if (self.info[UIApplicationLaunchOptionsURLKey]) {
    
    NSDictionary *parametrs = [self.info[UIApplicationLaunchOptionsURLKey] omn_query];
    searchRestaurantVC.qr = parametrs[@"qr"];
    
  }
  
#warning run with custom qr codes
//  searchRestaurantVC.qr = @"qr-code-for-1-ruby-bar-nsk-at-lenina-9";
//  searchRestaurantVC.qr = @"qr-code-for-3-travelerscoffee-nsk-at-karla-marksa-7";
//  searchRestaurantVC.qr = @"http://omnom.menu/qr/58428fff2c68200b7a6111644d544832";
//  searchRestaurantVC.qr = @"qr-code-for-2-saintlab-iiko";
//  searchRestaurantVC.qr = @"qr-code-3-at-saintlab-iiko";
//  searchRestaurantVC.qr = @"http://omnom.menu/qr/special-and-vip";
//  searchRestaurantVC.qr = @"http://m.2gis.ru/os/";

  NSData *decodeBeaconData = self.info[OMNVisitorNotificationLaunchKey];
  if (decodeBeaconData) {
    OMNVisitor *visitor = [NSKeyedUnarchiver unarchiveObjectWithData:decodeBeaconData];
    searchRestaurantVC.visitor = visitor;
  }

  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:searchRestaurantVC];
  navigationController.navigationBar.barStyle = UIBarStyleDefault;
  navigationController.delegate = _navigationControllerDelegate;
  [self presentViewController:navigationController animated:NO completion:nil];

}

- (void)requestAuthorization {
  
  OMNAuthorizationVC *authorizationVC = [[OMNAuthorizationVC alloc] init];
  authorizationVC.delegate = self;
  [self.navigationController pushViewController:authorizationVC animated:YES];
  
}

#pragma mark - OMNSearchRestaurantVCDelegate

- (void)searchRestaurantVCDidFinish:(OMNSearchRestaurantVC *)searchRestaurantVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNStartVC1Delegate

- (void)authorizationVCDidReceiveToken:(OMNAuthorizationVC *)startVC {
  
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:NO completion:^{
  
    [weakSelf startSearchingRestaurant];

  }];
  
}

@end
