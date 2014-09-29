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
#import "OMNAuthorisation.h"
#import "OMNAuthorizationVC.h"
#import "OMNSearchRestaurantVC.h"
#import "OMNNavigationController.h"
#import "OMNAnalitics.h"
#import "UINavigationController+omn_replace.h"
#import "OMNVisitorManager.h"

@interface OMNStartVC ()
<OMNAuthorizationVCDelegate,
OMNSearchRestaurantVCDelegate>

@end

@implementation OMNStartVC {
  OMNNavigationControllerDelegate *_navigationControllerDelegate;
  BOOL _tokenIsChecked;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _navigationControllerDelegate = [[OMNNavigationControllerDelegate alloc] init];
  
  self.navigationController.delegate = _navigationControllerDelegate;
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
  self.backgroundView.image = [UIImage omn_imageNamed:@"LaunchImage-700"];
  
  __weak typeof(self)weakSelf = self;
  [OMNAuthorisation authorisation].logoutCallback = ^{
    
    [weakSelf dismissViewControllerAnimated:YES completion:^{
      
      [weakSelf requestAuthorization];
      
    }];
  };

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (NO == _tokenIsChecked) {
    [self checkToken];
  }
  
}

- (void)checkToken {
  _tokenIsChecked = YES;
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {
    
    if (tokenIsValid) {
      [[OMNAnalitics analitics] logLogin];
      [weakSelf startSearchingRestaurant];
    }
    else {
      [weakSelf requestAuthorization];
    }
    
  }];
}

- (void)startSearchingRestaurant {
  
  OMNSearchRestaurantVC *searchRestaurantVC = [[OMNSearchRestaurantVC alloc] init];
  searchRestaurantVC.delegate = self;
  
  NSData *decodeBeaconData = self.info[OMNDecodeBeaconManagerNotificationLaunchKey];
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
