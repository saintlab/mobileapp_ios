//
//  UINavigationController+omn_replace.h
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (omn_replace)

- (void)omn_replaceCurrentViewControllerWithController:(UIViewController *)viewController animated:(BOOL)animated;

@end
