//
//  OMNLaunchFactory.h
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNLaunch.h"

@interface OMNLaunchFactory : NSObject

+ (OMNLaunch *)launchWithURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
+ (OMNLaunch *)launchWithLaunchOptions:(NSDictionary *)launchOptions;
+ (OMNLaunch *)launchWithLocalNotification:(UILocalNotification *)notification;
+ (OMNLaunch *)launchWithRemoteNotification:(NSDictionary *)notification;

@end
