//
//  OMNRestaurantMenuMediator.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMenuMediator.h"
#import "OMNUserInfoVC.h"
#import "OMNUserInfoTransitionDelegate.h"

#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNProductDetailsVC.h"

@interface OMNRestaurantMenuMediator ()
<OMNOrdersVCDelegate,
OMNProductDetailsVCDelegate,
OMNPayOrderVCDelegate>

@property (nonatomic, strong) UIViewController *rootViewController;

@end

@implementation OMNRestaurantMenuMediator {
  UIViewController *_rootViewController;
  OMNUserInfoTransitionDelegate *_transitionDelegate;
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
  self = [super init];
  if (self) {
    _rootViewController = rootViewController;
  }
  return self;
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [_rootViewController.navigationController popToViewController:_rootViewController animated:animated];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] init];
  
  _transitionDelegate = [[OMNUserInfoTransitionDelegate alloc] init];
  __weak typeof(self)weakSelf = self;
  _transitionDelegate.didFinishBlock = ^{
    
    [weakSelf.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navVC.transitioningDelegate = _transitionDelegate;
  navVC.modalPresentationStyle = UIModalPresentationCustom;
  [self.rootViewController presentViewController:navVC animated:YES completion:nil];
  
  return;
#ifdef __IPHONE_8_0
  if (&UIApplicationOpenSettingsURLString) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  }
#endif
  
}

- (void)showProductDetails:(OMNProduct *)product {
  
  OMNProductDetailsVC *productDetailsVC = [[OMNProductDetailsVC alloc] initWithProduct:product];
  productDetailsVC.delegate = self;
  [_rootViewController.navigationController pushViewController:productDetailsVC animated:YES];
  
}

#pragma mark - OMNProductDetailsVCDelegate

- (void)productDetailsVCDidFinish:(OMNProductDetailsVC *)productDetailsVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

- (void)processOrders:(NSArray *)orders {
  
  if (orders.count > 1) {
    
    [self selectOrderFromOrders:orders];
    
  }
  else if (1 == orders.count){
    
    [self showOrder:[orders firstObject]];
    
  }
  else {
#warning replace to real order
    //TODO: replce to no order situation
    [self popToRootViewControllerAnimated:YES];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"На этом столике нет заказов", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }
  
}

- (void)selectOrderFromOrders:(NSArray *)orders {
  
//  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithRestaurant:re orders:<#(NSArray *)#>];
//  ordersVC.delegate = self;
//  
//  OMNOrder *order = [orders firstObject];
//  ordersVC.navigationItem.title = order.tableId;
//  
//  [self popToRootViewControllerAnimated:NO];
//  [_rootViewController.navigationController pushViewController:ordersVC animated:YES];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  [self showOrder:order];
  
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  [self popToRootViewControllerAnimated:NO];
//  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithRestaurant:_ order:<#(OMNOrder *)#>];
//  paymentVC.delegate = self;
//  paymentVC.title = order.created;
//  [_rootViewController.navigationController pushViewController:paymentVC animated:YES];
  
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

-(void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  [self popToRootViewControllerAnimated:YES];
}

@end
