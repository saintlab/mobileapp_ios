//
//  OMNStartVC.m
//  restaurants
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "OMNLoginVC.h"
#import "OMNRegisterUserVC.h"
#import "OMNSearchTableVC.h"
#import "GRestaurantMenuVC.h"
#import "OMNAuthorisation.h"

@interface OMNStartVC ()
<OMNAuthorizationDelegate>

@end

@implementation OMNStartVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {

    if (tokenIsValid) {
      [weakSelf processWithToken:[OMNAuthorisation authorisation].token];
    }
    
  }];
  
}

- (IBAction)loginTap:(id)sender {
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  loginVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
  
}

- (IBAction)registerTap:(id)sender {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  registerUserVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerUserVC] animated:YES completion:nil];
  
}

#pragma mark - OMNAuthorizationDelegate

- (void)authorizationVC:(UIViewController *)authorizationVC didReceiveToken:(NSString *)token {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [[OMNAuthorisation authorisation] updateToken:token];
  
  [self processWithToken:token];
  
}

- (void)processWithToken:(NSString *)token {
  
  __weak typeof(self)weakSelf = self;
  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    if (decodeBeacon) {
      
      [weakSelf didFindBeacon:decodeBeacon];
      
    }
    
  }];
  
  [self.navigationController pushViewController:searchTableVC animated:YES];
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  //TODO: get actual restaurant
  NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
  OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:data];
  GRestaurantMenuVC *restaurantMenuVC = [[GRestaurantMenuVC alloc] initWithRestaurant:restaurant table:nil];
  [self.navigationController setViewControllers:@[restaurantMenuVC] animated:YES];
  
}

- (void)authorizationVCDidCancel:(UIViewController *)authorizationVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
