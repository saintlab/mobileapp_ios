//
//  OMNRestaurantMenuMediator.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"
#import "OMNUserInfoVC.h"
#import "OMNRestaurantActionsVC.h"
#import "OMNVisitor+network.h"
#import "OMNSearchVisitorVC.h"
#import "OMNAuthorization.h"
#import "OMNPushPermissionVC.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNError.h"

@interface OMNRestaurantMediator ()
<OMNUserInfoVCDelegate,
OMNOrdersVCDelegate,
OMNPayOrderVCDelegate>

@property (nonatomic, weak) OMNRestaurantActionsVC *restaurantActionsVC;

@end

@implementation OMNRestaurantMediator {
  
  __weak OMNOrdersVC *_ordersVC;
  
}

- (instancetype)initWithRootViewController:(OMNRestaurantActionsVC *)restaurantActionsVC {
  self = [super init];
  if (self) {
    
    _restaurantActionsVC = restaurantActionsVC;
    
  }
  return self;
}

- (OMNVisitor *)visitor {
  
  return _restaurantActionsVC.visitor;
  
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [self.restaurantActionsVC.navigationController popToViewController:self.restaurantActionsVC animated:animated];
  
}

- (void)pushViewController:(UIViewController *)vc {
  
  [self.restaurantActionsVC.navigationController pushViewController:vc animated:YES];
  
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithVisitor:self.visitor];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  navigationController.delegate = self.restaurantActionsVC.navigationController.delegate;
  [self.restaurantActionsVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)exitRestaurant {
  
  [self.restaurantActionsVC.delegate restaurantActionsVCDidFinish:self.restaurantActionsVC];
  
}

- (void)searchVisitorWithIcon:(UIImage *)icon completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock {
  
  if ([self.visitor.qr isValid]) {
    completionBlock(nil, self.visitor);
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  OMNSearchVisitorVC *searchBeaconVC = [[OMNSearchVisitorVC alloc] initWithParent:self.restaurantActionsVC.r1VC completion:^(OMNSearchVisitorVC *searchBeaconVC, OMNVisitor *visitor) {
    
    if ([weakSelf checkVisitor:visitor]) {
      
      completionBlock(searchBeaconVC, visitor);
      
    }
    else {
      
      [weakSelf visitorDidChange:visitor];
      
    }
    
  } cancelBlock:cancelBlock];
  searchBeaconVC.estimateAnimationDuration = 10.0;
  searchBeaconVC.circleIcon = icon;
  if (self.visitor.restaurant.is_demo) {
    
    searchBeaconVC.visitor = self.visitor;
    
  }
  [self pushViewController:searchBeaconVC];
  
}

- (BOOL)checkVisitor:(OMNVisitor *)visitor {
  
  if ([self.visitor isSameRestaurant:visitor]) {
    
    [self.visitor updateWithVisitor:visitor];
    return YES;
    
  }
  else {
    
    return NO;
    
  }

}

- (void)visitorDidChange:(OMNVisitor *)visitor {
  
  [self.restaurantActionsVC.delegate restaurantActionsVC:self.restaurantActionsVC didChangeVisitor:visitor];
  
}

- (void)callWaiterAction:(UIButton *)button {
  
  button.enabled = NO;
  __weak typeof(self)weakSelf = self;
  OMNVisitor *v = self.visitor;
  [self searchVisitorWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchVisitorVC *searchBeaconVC, OMNVisitor *visitor) {
    
    [v waiterCallWithFailure:^(NSError *error) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        button.enabled = YES;
        [searchBeaconVC finishLoading:^{
          
          [weakSelf.restaurantActionsVC showRestaurantAnimated:NO];
          [weakSelf popToRootViewControllerAnimated:YES];
          
        }];
        
      });
      
    }];
    
  } cancelBlock:^{
  
    button.enabled = YES;
    v.waiterIsCalled = NO;
    [weakSelf popToRootViewControllerAnimated:YES];
    
  }];
  
}

- (void)callBillAction:(__weak UIButton *)button {
  
  __weak typeof(self)weakSelf = self;
  button.enabled = NO;
  [self searchVisitorWithIcon:[UIImage imageNamed:@"bill_icon_white_big"] completion:^(OMNSearchVisitorVC *searchVisitorVC, OMNVisitor *visitor) {
    
    [weakSelf getOrdersForVisitor:visitor searchVisitorVC:searchVisitorVC];
    button.enabled = YES;
    
  } cancelBlock:^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    button.enabled = YES;
    
  }];
  
}

- (void)getOrdersForVisitor:(OMNVisitor *)visitor searchVisitorVC:(OMNSearchVisitorVC *)searchVisitorVC {
  
  __weak typeof(self)weakSelf = self;
  [visitor getOrders:^(NSArray *orders) {
    
    if (searchVisitorVC) {
      
      [searchVisitorVC finishLoading:^{
        
        [weakSelf checkPushNotificationForVisitor:visitor];
        
      }];
      
    }
    else {
      
      [weakSelf checkPushNotificationForVisitor:visitor];
      
    }
    
  } error:^(NSError *error) {
    
    [weakSelf processOrderError:error forVisitor:visitor];
    
  }];
  
}

- (void)checkPushNotificationForVisitor:(OMNVisitor *)visitor {

  if ([OMNAuthorization authorisation].pushNotificationsRequested) {
    
    [self processOrdersForVisitor:visitor];
    
  }
  else {
    
    if (!self.visitor.restaurant.is_demo &&
        visitor.orders.count &&
        !TARGET_IPHONE_SIMULATOR) {
      
      OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:self.restaurantActionsVC.r1VC];
      __weak typeof(self)weakSelf = self;
      pushPermissionVC.completionBlock = ^{
        
        [weakSelf processOrdersForVisitor:visitor];
        
      };
      [self pushViewController:pushPermissionVC];
      
    }
    else {
      
      [self processOrdersForVisitor:visitor];
      
    }
    
  }
  
}

- (void)processOrdersForVisitor:(OMNVisitor *)visitor {
  
  if (visitor.orders.count > 1) {
    
    [self selectOrderForVisitor:visitor];
    
  }
  else if (1 == visitor.orders.count){
    
    visitor.selectedOrder = [visitor.orders firstObject];
    [self processOrderForVisitor:visitor];
    
  }
  else {
    
    [self processNoOrders];
    
  }
  
}

- (void)processOrderForVisitor:(OMNVisitor *)visitor {
  
  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithVisitor:visitor];
  paymentVC.delegate = self;
  [self pushViewController:paymentVC];
  
}

- (void)processNoOrders {
  
  OMNCircleRootVC *noOrdersVC = [[OMNCircleRootVC alloc] initWithParent:self.restaurantActionsVC.r1VC];
  noOrdersVC.faded = YES;
  noOrdersVC.text = NSLocalizedString(@"На этом столике нет заказов", nil);
  noOrdersVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  __weak typeof(self)weakSelf = self;
  noOrdersVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:^{
      
      [weakSelf popToRootViewControllerAnimated:YES];
      
    }]
    ];
  [self pushViewController:noOrdersVC];
  
}

- (void)processOrderError:(NSError *)error forVisitor:(OMNVisitor *)visitor {
  
  OMNError *omnomError = [OMNError omnnomErrorFromError:error];
  
  OMNCircleRootVC *noInternetVC = [[OMNCircleRootVC alloc] initWithParent:self.restaurantActionsVC.r1VC];
  noInternetVC.text = omnomError.localizedDescription;
  noInternetVC.faded = YES;
  noInternetVC.circleIcon = [UIImage imageNamed:@"unlinked_icon_big"];
  __weak typeof(self)weakSelf = self;
  noInternetVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"REPEAT_BUTTON_TITLE", @"Повторить") image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      [weakSelf callBillAction:nil];
      
    }]
    ];
  noInternetVC.didCloseBlock = ^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    
  };
  [self popToRootViewControllerAnimated:NO];
  [self pushViewController:noInternetVC];
  
}

- (void)selectOrderForVisitor:(OMNVisitor *)visitor {
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithVisitor:visitor];
  ordersVC.delegate = self;
  [self pushViewController:ordersVC];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self.restaurantActionsVC.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  
  _ordersVC = ordersVC;
  [self processOrderForVisitor:ordersVC.visitor];
  
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  
  if (self.visitor.restaurant.is_demo) {
    
    [self.restaurantActionsVC.delegate restaurantActionsVCDidFinish:self.restaurantActionsVC];
    
  }
  else {
    
    [self popToRootViewControllerAnimated:YES];
    
  }
  
}

- (void)payOrderVCRequestOrders:(OMNPayOrderVC *)ordersVC {
  
  if (_ordersVC) {
    
    [self.restaurantActionsVC.navigationController popToViewController:_ordersVC animated:YES];
    
  }
  
}

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  
  [self popToRootViewControllerAnimated:YES];
  
}

@end
