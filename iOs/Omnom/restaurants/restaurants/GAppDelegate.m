//
//  GAppDelegate.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import "OMNFoundBeaconsHandler.h"
#import "OMNTableOrdersVC.h"
#import "GRestaurantsVC.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import "OMNAuthorisation.h"
#import "OMNConstants.h"
#import "OMNOperationManager.h"
#import "OMNSearchTableVC.h"
#import "GRestaurantMenuVC.h"

@implementation GAppDelegate {
  UIImageView *_splashIV;
  OMNFoundBeaconsHandler *_foundBeaconsHandler;
  CTTelephonyNetworkInfo* _info;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [OMNAuthorisation authorisation];

  [[OMNOperationManager sharedManager].requestSerializer setValue:@"1e142e6277b12b7e1110478a24caee8f006a9349e86970c890203d6266209463" forHTTPHeaderField:@"x-authentication-token"];

//  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[GRestaurantsVC alloc] init]];
//  return YES;
  
  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {

    NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
    OMNRestaurant *r = [[OMNRestaurant alloc] initWithData:data];
    GRestaurantMenuVC *restaurantMenuVC = [[GRestaurantMenuVC alloc] initWithRestaurant:r table:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:restaurantMenuVC];
//    [self.navigationController pushViewController:restaurantMenuVC animated:YES];
    
  }];
  self.window.rootViewController = searchTableVC;
  
  
  
//  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[GRestaurantsVC alloc] init]];
  
//  if (kUseStubData) {
//    [[[UIAlertView alloc] initWithTitle:@"Using mock data" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//  }
//  
//  if (kUseStubBeacon) {
//    [[[UIAlertView alloc] initWithTitle:@"Using mock beacon" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//  }
  
  return YES;
  
}

- (void)showSplash {

  _splashIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash"]];
  _splashIV.opaque = YES;
  [self.window addSubview:_splashIV];
  
}

- (void)hideSplash {
  
  [UIView animateWithDuration:0.2 animations:^{
    
    _splashIV.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [_splashIV removeFromSuperview];
    _splashIV = nil;
    
  }];
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
