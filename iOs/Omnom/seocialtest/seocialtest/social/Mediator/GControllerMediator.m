//
//  GControllerMediator.m
//  seocialtest
//
//  Created by tea on 12.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GControllerMediator.h"
#import "GSocialNetwork.h"
#import "GUserDetailsVC.h"
#import "GCongratulationsVC.h"
#import <BlocksKit+UIKit.h>
//#import "OMNPayCardVC.h"
//#import "OMNPaymentVC.h"
//#import "OMNCalculatorVC.h"
//#import "GOrder.h"

@interface GControllerMediator ()
//<OMNPayCardVCDelegate>

@property (nonatomic, weak) UIViewController *currentController;

@end

@implementation GControllerMediator {
  
  UIViewController *_rootViewController;
  
}

+(instancetype)mediator {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
  
  if (nil == _rootViewController) {
    self.currentController = _rootViewController;
  }
  
  _rootViewController = rootViewController;
  
}

- (UINavigationController *)navigationController {
  return _rootViewController.navigationController;
}

- (void)showUserDetails:(GSocialNetwork *)socialNetwork vc:(UINavigationController *)navVC {
  
  GUserDetailsVC *userDetailsVC = [[GUserDetailsVC alloc] initWithSocialNetwork:socialNetwork];
  [navVC pushViewController:userDetailsVC animated:YES];
  
}

- (void)showPayInfo {
  
//  OMNPayCardVC *payVC = [[OMNPayCardVC alloc] init];
//  payVC.delegate = self;
//  [self.navigationController pushViewController:payVC animated:YES];
  
}


- (void)showPaymentScreen {
  
  /*
  NSMutableArray *orders = [NSMutableArray arrayWithCapacity:50];
  for (int i = 0; i < 20; i++) {
    
    OMNOrderItem *orderItem = [[OMNOrderItem alloc] init];
    orderItem.name = [NSString stringWithFormat:@"Продукт %d", arc4random() % 100 + 1];
    orderItem.price = arc4random() % 1000;
    orderItem.icon = [UIImage imageNamed:@""];
    [orders addObject:orderItem];
    
  }

  GOrder *order = [[GOrder alloc] init];
  order.items = orders;
  
  OMNPaymentVC *paymentVC = [[OMNPaymentVC alloc] initWithOrder:order];
  
  __weak typeof(self)weakSelf = self;
  
  paymentVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    [weakSelf.navigationController popViewControllerAnimated:YES];
    
  }];
  paymentVC.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  [self.navigationController pushViewController:paymentVC animated:YES];
  */
}


#pragma mark - GPayVCDelegate 
/*
- (void)payVC:(OMNPayCardVC *)payVC requestPayWithCardInfo:(OMNCardInfo *)cardInfo {
  
  [self.navigationController popToRootViewControllerAnimated:NO];
  
  GCongratulationsVC *congratulationsVC = [[GCongratulationsVC alloc] init];
  congratulationsVC.navigationItem.title = NSLocalizedString(@"Congratulations", nil);
  
  __weak typeof(self)weakSelf = self;
  congratulationsVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  }];
  
  [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:congratulationsVC] animated:YES completion:nil];
  
}
*/

@end
