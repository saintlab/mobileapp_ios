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

@implementation OMNStartVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
  @weakify(self)
  [OMNAuthorization authorisation].logoutCallback = ^{
    
    @strongify(self)
    [self reloadSearchingRestaurant];
    
  };
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self checkUserToken];
  
}

- (void)reloadSearchingRestaurant {

  [OMNLaunchHandler sharedHandler].launchOptions = nil;
  [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)checkUserToken {
  
  @weakify(self)
  [self.navigationController omn_popToViewController:self animated:YES completion:^{

    @strongify(self)
    if ([OMNAuthorization authorisation].token) {
      
      [self startSearchingRestaurant];
      
    }
    else {
      
      [self requestAuthorization];
      
    }
    
  }];
  
}

- (void)startSearchingRestaurant {
  
  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] init];
  searchRestaurantVC.delegate = self;
  
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:searchRestaurantVC];
  navigationController.navigationBar.barStyle = UIBarStyleDefault;
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [self presentViewController:navigationController animated:NO completion:nil];
  
}

- (void)requestAuthorization {
  
  OMNAuthorizationVC *authorizationVC = [[OMNAuthorizationVC alloc] init];
  authorizationVC.delegate = self;
  [self.navigationController pushViewController:authorizationVC animated:YES];
  
}

#pragma mark - OMNSearchRestaurantVCDelegate

- (void)searchRestaurantVCDidFinish:(OMNSearchRestaurantVC *)searchRestaurantVC {
  [self reloadSearchingRestaurant];
}

#pragma mark - OMNStartVC1Delegate

- (void)authorizationVCDidReceiveToken:(OMNAuthorizationVC *)startVC {
  [self.navigationController popToViewController:self animated:NO];
}

@end
