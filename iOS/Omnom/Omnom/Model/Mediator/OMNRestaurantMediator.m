//
//  OMNRestaurantMenuMediator.m
//  restaurants
//
//  Created by tea on 04.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantMediator.h"
#import "OMNUserInfoVC.h"
#import "OMNRestaurantInfoVC.h"
#import "OMNR1VC.h"
#import "OMNVisitor.h"
#import "OMNSearchBeaconVC.h"
#import "OMNAuthorisation.h"
#import "OMNPushPermissionVC.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"

@interface OMNRestaurantMediator ()
<OMNRestaurantInfoVCDelegate,
OMNUserInfoVCDelegate,
OMNOrdersVCDelegate,
OMNPayOrderVCDelegate>

@property (nonatomic, weak) OMNR1VC *restaurantVC;

@end

@implementation OMNRestaurantMediator {
  __weak OMNOrdersVC *_ordersVC;
}

- (instancetype)initWithRootViewController:(OMNR1VC *)restaurantVC {
  self = [super init];
  if (self) {
    _restaurantVC = restaurantVC;
  }
  return self;
}

- (void)popToRootViewControllerAnimated:(BOOL)animated {
  
  [self.restaurantVC.navigationController popToViewController:self.restaurantVC animated:animated];
  
}

- (void)pushViewController:(UIViewController *)vc {
  [self.restaurantVC.navigationController pushViewController:vc animated:YES];
}

- (void)showUserProfile {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] initWithVisitor:_restaurantVC.visitor];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  [self.restaurantVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)showRestaurantInfo {
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithVisitor:self.restaurantVC.visitor];
  restaurantInfoVC.delegate = self;
  [self pushViewController:restaurantInfoVC];

}

- (void)searchVisitorWithIcon:(UIImage *)icon completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock {
  
  __weak typeof(self)weakSelf = self;
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithParent:self.restaurantVC completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
    
    if ([weakSelf checkVisitor:visitor]) {
      completionBlock(searchBeaconVC, visitor);
    }
    else {
      [weakSelf visitorDidChange:visitor];
    }
    
  } cancelBlock:cancelBlock];
  searchBeaconVC.estimateAnimationDuration = 10.0;
  searchBeaconVC.circleIcon = icon;
  if (self.restaurantVC.visitor.restaurant.is_demo) {
    searchBeaconVC.visitor = self.restaurantVC.visitor;
  }
  [self pushViewController:searchBeaconVC];
  
}

- (BOOL)checkVisitor:(OMNVisitor *)visitor {
  
  if ([self.restaurantVC.visitor isSameRestaurant:visitor]) {
    [self.restaurantVC.visitor updateWithVisitor:visitor];
    return YES;
  }
  else {
    return NO;
  }

}

- (void)visitorDidChange:(OMNVisitor *)visitor {
  
  [self.restaurantVC.delegate restaurantVC:self.restaurantVC didChangeVisitor:visitor];
  
}

- (void)callWaiterAction {
  
  __weak typeof(self)weakSelf = self;
  OMNVisitor *v = self.restaurantVC.visitor;
  [self searchVisitorWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
    
    [v waiterCallWithFailure:^(NSError *error) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          [weakSelf popToRootViewControllerAnimated:YES];
          
        }];
        
      });
      
    }];
    
  } cancelBlock:^{
    
    v.waiterIsCalled = NO;
    [weakSelf popToRootViewControllerAnimated:YES];
    
  }];
  
}

- (void)callBillAction {
  
  __weak typeof(self)weakSelf = self;
  [self searchVisitorWithIcon:[UIImage imageNamed:@"bill_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
    
    [visitor getOrders:^(NSArray *orders) {
      
      [searchBeaconVC finishLoading:^{
        [weakSelf checkPushNotificationForVisitor:visitor];
      }];
      
    } error:^(NSError *error) {
      
      [weakSelf processNoOrders];
      
    }];
    
  } cancelBlock:^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    
  }];
  
}

- (void)checkPushNotificationForVisitor:(OMNVisitor *)visitor {
  
  if ([OMNAuthorisation authorisation].pushNotificationsRequested) {
    
    [self processOrdersForVisitor:visitor];
    
  }
  else {
    
    if (!self.restaurantVC.visitor.restaurant.is_demo &&
        visitor.orders.count &&
        !TARGET_IPHONE_SIMULATOR) {
      OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:self.restaurantVC];
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
  
  OMNCircleRootVC *didFailOmnomVC = [[OMNCircleRootVC alloc] initWithParent:self.restaurantVC];
  didFailOmnomVC.faded = YES;
  didFailOmnomVC.text = NSLocalizedString(@"На этом столике нет заказов", nil);
  didFailOmnomVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Ок", nil) image:nil block:^{
      
      [weakSelf popToRootViewControllerAnimated:YES];
      
    }]
    ];
  [self pushViewController:didFailOmnomVC];
  
}

- (void)selectOrderForVisitor:(OMNVisitor *)visitor {
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithVisitor:visitor];
  ordersVC.delegate = self;
  [self pushViewController:ordersVC];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  [self.restaurantVC.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OMNRestaurantInfoVCDelegate

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC {
  [self popToRootViewControllerAnimated:YES];
}

- (void)restaurantInfoVCShowUserInfo:(OMNRestaurantInfoVC *)restaurantInfoVC {
  [self showUserProfile];
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
  
  if (self.restaurantVC.visitor.restaurant.is_demo) {
    [self.restaurantVC.delegate restaurantVCDidFinish:self.restaurantVC];
  }
  else {
    [self popToRootViewControllerAnimated:YES];
  }
  
}

- (void)payOrderVCRequestOrders:(OMNPayOrderVC *)ordersVC {
  
  if (_ordersVC) {
    [self.restaurantVC.navigationController popToViewController:_ordersVC animated:YES];
  }
  
}

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  [self popToRootViewControllerAnimated:YES];
}

@end
