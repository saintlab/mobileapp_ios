//
//  GAppDelegate.m
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GAppDelegate.h"
#import "OMNAuthorisation.h"
#import "OMNSearchTableVC.h"
#import "GRestaurantMenuVC.h"

@implementation GAppDelegate {
  UIImageView *_splashIV;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
  NSLog(@"%@", [UIFont familyNames]);
  NSLog(@"%d", [UIFont familyNames].count);
  NSLog(@"%@", [UIFont fontNamesForFamilyName:@"FuturaDemiCTT"]);
  NSLog(@"%@", [UIFont fontNamesForFamilyName:@""]);
  NSLog(@"%@", [UIFont fontNamesForFamilyName:@"Futura"]);
  
  [OMNAuthorisation authorisation];
  
  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
    OMNRestaurant *r = [[OMNRestaurant alloc] initWithData:data];
    GRestaurantMenuVC *restaurantMenuVC = [[GRestaurantMenuVC alloc] initWithRestaurant:r table:nil];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:restaurantMenuVC];
    
  }];
  self.window.rootViewController = searchTableVC;
  
  
  return YES;
  
}

- (void)showSplash {
  
  _splashIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Splash"]];
  _splashIV.opaque = YES;
  [self.window addSubview:_splashIV];
  
}

- (void)hideSplash {
  
  [UIView animateWithDuration:0.5 animations:^{
    
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
