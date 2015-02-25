//
//  UINavigationController+omn_replace.h
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (omn_replace)

- (void)omn_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

- (NSArray *)omn_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock;

- (void)omn_didShowViewController:(UIViewController *)viewController;

@end
