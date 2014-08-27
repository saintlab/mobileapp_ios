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

@property (nonatomic, strong) OMNR1VC *restaurantVC;

@end

@implementation OMNRestaurantMediator {
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
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] init];
  userInfoVC.delegate = self;
  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  [self.restaurantVC.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)showRestaurantInfo {
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithVisitor:self.restaurantVC.visitor];
  restaurantInfoVC.delegate = self;
  [self pushViewController:restaurantInfoVC];

}


- (void)searchBeaconWithIcon:(UIImage *)icon completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock {
  
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithParent:self.restaurantVC completion:completionBlock cancelBlock:cancelBlock];
  searchBeaconVC.estimateAnimationDuration = 2.0;
  searchBeaconVC.circleIcon = icon;
  if (self.restaurantVC.visitor.restaurant.is_demo) {
    searchBeaconVC.visitor = self.restaurantVC.visitor;
  }
  [self pushViewController:searchBeaconVC];
  
}

- (void)callBillAction {
  
  __weak typeof(self)weakSelf = self;
  [self searchBeaconWithIcon:[UIImage imageNamed:@"bill_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *decodeBeacon) {
    
    [decodeBeacon getOrders:^(NSArray *orders) {
      
      [searchBeaconVC finishLoading:^{
        [weakSelf checkPushNotificationAndProcessBeacon:decodeBeacon];
      }];
      
    } error:^(NSError *error) {
      
      [weakSelf processNoOrders];
      
    }];
    
  } cancelBlock:^{
    
    [weakSelf popToRootViewControllerAnimated:YES];
    
  }];
  
}

- (void)checkPushNotificationAndProcessBeacon:(OMNVisitor *)decodeBeacon {
  
  if ([OMNAuthorisation authorisation].pushNotificationsRequested) {
    
    [self processOrdersAtBeacon:decodeBeacon];
    
  }
  else {
    
    if (!self.restaurantVC.visitor.restaurant.is_demo &&
        decodeBeacon.orders.count &&
        !TARGET_IPHONE_SIMULATOR) {
      OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:self.restaurantVC];
      __weak typeof(self)weakSelf = self;
      pushPermissionVC.completionBlock = ^{
        [weakSelf processOrdersAtBeacon:decodeBeacon];
      };
      [self pushViewController:pushPermissionVC];
      
    }
    else {
      [self processOrdersAtBeacon:decodeBeacon];
    }
    
  }
  
}


- (void)processOrdersAtBeacon:(OMNVisitor *)decodeBeacon {
  
  if (decodeBeacon.orders.count > 1) {
    
    [self selectOrderAtBeacon:decodeBeacon];
    
  }
  else if (1 == decodeBeacon.orders.count){
    
    decodeBeacon.selectedOrder = [decodeBeacon.orders firstObject];
    [self processOrderAtBeacon:decodeBeacon];
    
  }
  else {
    
    [self processNoOrders];
    
  }
  
}

- (void)processOrderAtBeacon:(OMNVisitor *)visitor {
  
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

- (void)selectOrderAtBeacon:(OMNVisitor *)visitor {
  
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
  [self processOrderAtBeacon:ordersVC.decodeBeacon];
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  [self popToRootViewControllerAnimated:YES];
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  
  if (self.restaurantVC.visitor.restaurant.is_demo) {
    [self.restaurantVC.delegate r1VCDidFinish:self.restaurantVC];
  }
  else {
    [self popToRootViewControllerAnimated:YES];
  }
  
}

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  [self popToRootViewControllerAnimated:YES];
}

@end
