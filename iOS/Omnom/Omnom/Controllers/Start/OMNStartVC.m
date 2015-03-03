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
OMNSearchRestaurantVCDelegate>

@end

@implementation OMNStartVC {
  
  BOOL _authorizationPresented;
  OMNSearchRestaurantVC *_searchRestaurantVC;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
  @weakify(self)
  [OMNAuthorization authorisation].logoutCallback = ^{
    
    @strongify(self)
    [self dismissViewControllerAnimated:YES completion:^{
      
      [self requestAuthorizationIfNeeded];
      
    }];
  };
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self checkUserToken];
  
}

- (void)checkUserToken {
  
  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{

    @strongify(self)
    if ([OMNAuthorization authorisation].token) {
      
      [self reloadSearchingRestaurant];
      
    }
    else {
      
      [self requestAuthorizationIfNeeded];
      
    }
    
  }];
  
}

- (void)reloadSearchingRestaurant {

  if (_searchRestaurantVC) {
    
    _searchRestaurantVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
    
  }
  else {
    
    [self startSearchingRestaurant];
    
  }
  
}

- (void)startSearchingRestaurant {
  
  if ([OMNAuthorization authorisation].token &&
      self.isViewLoaded) {

    _searchRestaurantVC = [[OMNSearchRestaurantVC alloc] init];
    _searchRestaurantVC.delegate = self;
    
    UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:_searchRestaurantVC];
    navigationController.navigationBar.barStyle = UIBarStyleDefault;
    navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
    [self presentViewController:navigationController animated:NO completion:nil];

  }
  
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
  
  _searchRestaurantVC = nil;
  [OMNLaunchHandler sharedHandler].launchOptions = nil;
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNStartVC1Delegate

- (void)authorizationVCDidReceiveToken:(OMNAuthorizationVC *)startVC {
  
  _authorizationPresented = NO;
  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:NO completion:^{

    @strongify(self)
    [self startSearchingRestaurant];

  }];
  
}

@end
