//
//  OMNLaunchHandler.h
//  omnom
//
//  Created by tea on 10.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNLaunchOptions.h"

@protocol OMNLaunchHandlerDelegate;

@interface OMNLaunchHandler : NSObject

@property (nonatomic, weak) id<OMNLaunchHandlerDelegate> delegate;

+ (instancetype)sharedHandler;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end

@protocol OMNLaunchHandlerDelegate <NSObject>

- (void)launchHandler:(OMNLaunchHandler *)launchHandler didReceiveLaunchOptions:(OMNLaunchOptions *)launchOptions;

@end