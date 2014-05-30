//
//  GControllerMediator.h
//  seocialtest
//
//  Created by tea on 12.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@class GSocialNetwork;

@interface GControllerMediator : NSObject



+ (instancetype)mediator;

- (void)setRootViewController:(UIViewController *)rootViewController;

- (void)showUserDetails:(GSocialNetwork *)socialNetwork vc:(UINavigationController *)navVC;

- (void)showPaymentScreen;

- (void)showPayInfo;

@end
