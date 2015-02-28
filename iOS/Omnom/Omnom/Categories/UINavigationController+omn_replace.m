//
//  UINavigationController+omn_replace.m
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UINavigationController+omn_replace.h"

@implementation UINavigationController (omn_replace)

- (void)omn_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock {
  
  [self pushViewController:viewController animated:animated];
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), completionBlock);
  
}

- (NSArray *)omn_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock {
  
  if ([self.topViewController isEqual:viewController]) {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), completionBlock);
    return @[];
    
  }
  else {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), completionBlock);
    return [self popToViewController:viewController animated:animated];

  }
  
}

@end
