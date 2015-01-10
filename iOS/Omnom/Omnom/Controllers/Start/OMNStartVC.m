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
#import "NSURL+omn_query.h"
#import "OMNLaunchHandler.h"

@interface OMNStartVC ()
<OMNAuthorizationVCDelegate,
OMNSearchRestaurantVCDelegate,
OMNLaunchHandlerDelegate>

@end

@implementation OMNStartVC {
  
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  BOOL _authorizationPresented;
  OMNLaunchOptions *_launchOptions;
  
}

- (instancetype)initWithLaunchOptions:(OMNLaunchOptions *)launchOptions {
  self = [super init];
  if (self) {
    
    _launchOptions = launchOptions;
    
  }
  return self;
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
      
      [weakSelf requestAuthorizationIfNeeded];
      
    }];
  };

  [OMNLaunchHandler sharedHandler].delegate = self;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self checkUserToken];
  
}

- (void)checkUserToken {
  
  __weak typeof(self)weakSelf = self;
  [self.navigationController omn_popToViewController:self animated:YES completion:^{

    if ([OMNAuthorization authorisation].token) {
      
      [weakSelf startSearchingRestaurant];
      
    }
    else {
      
      [weakSelf requestAuthorizationIfNeeded];
      
    }
    
  }];
  
}

- (void)startSearchingRestaurant {

  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] initWithLaunchOptions:_launchOptions];
  searchRestaurantVC.delegate = self;

  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:searchRestaurantVC];
  navigationController.navigationBar.barStyle = UIBarStyleDefault;
  navigationController.delegate = _navigationControllerDelegate;
  [self presentViewController:navigationController animated:NO completion:nil];

}

- (void)requestAuthorizationIfNeeded {
  
  if (_authorizationPresented) {
    return;
  }
  _authorizationPresented = YES;
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
  _authorizationPresented = NO;
  [self.navigationController omn_popToViewController:self animated:NO completion:^{
  
    [weakSelf startSearchingRestaurant];

  }];
  
}

#pragma mark - OMNLaunchHandlerDelegate 

- (void)launchHandler:(OMNLaunchHandler *)launchHandler didReceiveLaunchOptions:(OMNLaunchOptions *)launchOptions {
  
  if (![OMNAuthorization authorisation].token) {
    return;
  }
  
  _launchOptions = launchOptions;
  __weak typeof(self)weakSelf = self;
  [self dismissViewControllerAnimated:YES completion:^{
    
    [weakSelf startSearchingRestaurant];
    
  }];
  
}

@end
