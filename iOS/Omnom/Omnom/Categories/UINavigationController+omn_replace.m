//
//  UINavigationController+omn_replace.m
//  restaurants
//
//  Created by tea on 28.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "UINavigationController+omn_replace.h"
#import <objc/runtime.h>

static const char kNavigationControllerPushBlockKey;
static const char kNavigationControllerPushControllerKey;

static const char kNavigationControllerPopToBlockKey;
static const char kNavigationControllerPopToControllerKey;

@implementation UINavigationController (omn_replace)

- (void)omn_pushViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock {
  
  objc_setAssociatedObject(self, &kNavigationControllerPushBlockKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  objc_setAssociatedObject(self, &kNavigationControllerPushControllerKey, viewController, OBJC_ASSOCIATION_ASSIGN);

  [self pushViewController:viewController animated:animated];

}

- (NSArray *)omn_popToViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(dispatch_block_t)completionBlock {
  
  if ([self.topViewController isEqual:viewController]) {
    
    completionBlock();
    return @[];
    
  }
  else {
    
    objc_setAssociatedObject(self, &kNavigationControllerPopToBlockKey, completionBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kNavigationControllerPopToControllerKey, viewController, OBJC_ASSOCIATION_ASSIGN);
    return [self popToViewController:viewController animated:animated];

  }
  
}

- (void)omn_didShowViewController:(UIViewController *)viewController {
  
  UIViewController *pushViewController = objc_getAssociatedObject(self, &kNavigationControllerPushControllerKey);
  if ([viewController isEqual:pushViewController]) {
    
    objc_setAssociatedObject(self, &kNavigationControllerPushControllerKey, nil, OBJC_ASSOCIATION_ASSIGN);
    
    dispatch_block_t completionBlock = objc_getAssociatedObject(self, &kNavigationControllerPushBlockKey);
    if (completionBlock) {
      completionBlock();
      objc_setAssociatedObject(self, &kNavigationControllerPushBlockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
  }
  
  UIViewController *popToViewController = objc_getAssociatedObject(self, &kNavigationControllerPopToControllerKey);
  if ([viewController isEqual:popToViewController]) {
    
    objc_setAssociatedObject(self, &kNavigationControllerPopToControllerKey, nil, OBJC_ASSOCIATION_ASSIGN);
    
    dispatch_block_t completionBlock = objc_getAssociatedObject(self, &kNavigationControllerPopToBlockKey);
    if (completionBlock) {
      completionBlock();
      objc_setAssociatedObject(self, &kNavigationControllerPopToBlockKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
  }
  
}

@end
