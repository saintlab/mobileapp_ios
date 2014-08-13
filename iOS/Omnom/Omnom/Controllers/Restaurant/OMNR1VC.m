//
//  OMNR1VC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNR1VC.h"
#import "OMNSearchBeaconVC.h"
#import "OMNPayOrderVC.h"
#import "OMNOrdersVC.h"
#import "OMNOperationManager.h"
#import "OMNAuthorisation.h"
#import "OMNUserInfoVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNSocketManager.h"
#import "UIImage+omn_helper.h"
#import "OMNPushPermissionVC.h"
#import "OMNRestaurantInfoVC.h"

@interface OMNR1VC ()
<OMNPayOrderVCDelegate,
OMNOrdersVCDelegate,
OMNUserInfoVCDelegate,
OMNRestaurantInfoVCDelegate>

@end

@implementation OMNR1VC {
  OMNRestaurant *_restaurant;
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super initWithParent:nil];
  if (self) {
    _restaurant = restaurant;
    self.circleIcon = restaurant.logo;
    //    _productsModel = [[OMNProductsModel alloc] init];
    //    _restaurantMenuMediator = [[OMNRestaurantMenuMediator alloc] initWithRootViewController:self];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(userProfileTap)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
  
  self.backgroundImage = _restaurant.background;
  self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:_restaurant.background_color];

  [self addActionsBoard];
  
  [self socketConnect];
  
}

- (void)userProfileTap {
  
  OMNUserInfoVC *userInfoVC = [[OMNUserInfoVC alloc] init];
  userInfoVC.delegate = self;
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:userInfoVC];
  [self presentViewController:navVC animated:YES completion:nil];
  
}

- (void)socketConnect {
  
  [[OMNSocketManager manager] connectWithToken:[OMNAuthorisation authorisation].token];
  
}

- (void)addActionsBoard {
  
  UIButton *callWaiterButton = [[UIButton alloc] init];
  [callWaiterButton setImage:[UIImage imageNamed:@"call_waiter_icon_small"] forState:UIControlStateNormal];
  [callWaiterButton setTitle:NSLocalizedString(@"Официант", nil) forState:UIControlStateNormal];
  [callWaiterButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected];
  [callWaiterButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected|UIControlStateHighlighted];
  [callWaiterButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
  [callWaiterButton sizeToFit];
  
  UIButton *callBillButton = [[UIButton alloc] init];
  [callBillButton setImage:[UIImage imageNamed:@"call_bill_icon_small"] forState:UIControlStateNormal];
  [callBillButton setTitle:NSLocalizedString(@"Счет", nil) forState:UIControlStateNormal];
  [callBillButton addTarget:self action:@selector(callBillTap) forControlEvents:UIControlEventTouchUpInside];
  [callBillButton sizeToFit];
  
  self.toolbarItems =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
    ];
  
//  [self addBottomButtons];
//  
//  [self.leftBottomButton setImage:[UIImage imageNamed:@"call_waiter_icon_small"] forState:UIControlStateNormal];
//  [self.leftBottomButton setTitle:NSLocalizedString(@"Официант", nil) forState:UIControlStateNormal];
//  [self.leftBottomButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected];
//  [self.leftBottomButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected|UIControlStateHighlighted];
//  [self.leftBottomButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
//  
//  [self.rightBottomButton setImage:[UIImage imageNamed:@"call_bill_icon_small"] forState:UIControlStateNormal];
//  [self.rightBottomButton setTitle:NSLocalizedString(@"Счет", nil) forState:UIControlStateNormal];
//  [self.rightBottomButton addTarget:self action:@selector(callBillTap) forControlEvents:UIControlEventTouchUpInside];
  
  UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
  [actionButton addTarget:self action:@selector(showInfoTap) forControlEvents:UIControlEventTouchUpInside];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:actionButton];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.circleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:50.0f]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationItem setHidesBackButton:YES animated:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self.navigationController setToolbarHidden:NO animated:animated];

//  self.bottomViewConstraint.constant = 0.0f;
//  [UIView animateWithDuration:0.3 animations:^{
//    [self.view layoutIfNeeded];
//  }];
  
}

- (void)showInfoTap {
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] init];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
}

- (void)callWaiterTap {
  
  UIImage *logo = _restaurant.logo;
  
  if (self.leftBottomButton.selected) {
    
    [_restaurant waiterCallStopCompletion:^{
      
      [self.circleButton setImage:logo forState:UIControlStateNormal];
      self.leftBottomButton.selected = NO;

    } failure:^(NSError *error) {

      NSLog(@"waiterCallStopError>%@", error);
      
    }];
    return;
  }
  
  OMNSearchBeaconVC *sbVC = [[OMNSearchBeaconVC alloc] initWithParent:self completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [_restaurant waiterCallForTableID:decodeBeacon.tableId completion:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          self.leftBottomButton.selected = YES;
          [self.circleButton setImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"] forState:UIControlStateNormal];
          [self.navigationController popToViewController:self animated:YES];
          
        }];
        
      });
      
    } failure:^(NSError *error) {
      
      NSLog(@"error>%@", error);
      
    }];
    
  } cancelBlock:^{
    
    self.leftBottomButton.selected = NO;
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  sbVC.estimateAnimationDuration = 2.0;
  sbVC.circleIcon = [UIImage imageNamed:@"bell_ringing_icon_white_big"];
  [self.navigationController pushViewController:sbVC animated:YES];
  
}

- (void)callBillTap {

  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithParent:self completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [restaurant getOrdersForTableID:decodeBeacon.tableId orders:^(NSArray *orders) {
      
      [searchBeaconVC finishLoading:^{
        [weakSelf checkPushNotificationForOrders:orders];
      }];
      
    } error:^(NSError *error) {
      
      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      [weakSelf.navigationController popToViewController:weakSelf animated:YES];
      
    }];
    
  } cancelBlock:^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  }];
  searchBeaconVC.estimateAnimationDuration = 2.0;
  searchBeaconVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
}

- (void)checkPushNotificationForOrders:(NSArray *)orders {
  
  if ([OMNAuthorisation authorisation].pushNotificationsRequested) {
    
    [self processOrders:orders];
    
  }
  else {

    if (orders.count &&
        !TARGET_IPHONE_SIMULATOR) {
      OMNPushPermissionVC *pushPermissionVC = [[OMNPushPermissionVC alloc] initWithParent:self];
      __weak typeof(self)weakSelf = self;
      pushPermissionVC.completionBlock = ^{
        [weakSelf processOrders:orders];
      };
      [self.navigationController pushViewController:pushPermissionVC animated:YES];
      
    }
    else {
      [self processOrders:orders];
    }
    
  }
  
}

- (void)processOrders:(NSArray *)orders {
  
  if (orders.count > 1) {
    
    [self selectOrderFromOrders:orders];
    
  }
  else if (1 == orders.count){
    
    [self showOrder:[orders firstObject]];
    
  }
  else {

    [self showNoOrder];
    
  }
  
}

- (void)showNoOrder {
  
  OMNCircleRootVC *didFailOmnomVC = [[OMNCircleRootVC alloc] initWithParent:self];
  didFailOmnomVC.faded = YES;
  didFailOmnomVC.text = NSLocalizedString(@"На этом столике нет заказов", nil);
  didFailOmnomVC.circleIcon = [UIImage imageNamed:@"bill_icon_white_big"];
  
  didFailOmnomVC.buttonInfo =
  @{
    @"title" : NSLocalizedString(@"Ок", nil),
    };
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.actionBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:didFailOmnomVC animated:YES];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithRestaurant:_restaurant order:order];
  paymentVC.delegate = self;
  paymentVC.title = order.created;
  [self.navigationController pushViewController:paymentVC animated:YES];
  
}


- (void)selectOrderFromOrders:(NSArray *)orders {
  
  OMNOrdersVC *ordersVC = [[OMNOrdersVC alloc] initWithRestaurant:_restaurant orders:orders];
  ordersVC.delegate = self;
  
  OMNOrder *order = [orders firstObject];
  ordersVC.navigationItem.title = order.tableId;
  [self.navigationController pushViewController:ordersVC animated:YES];
  
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - OMNOrdersVCDelegate

- (void)ordersVC:(OMNOrdersVC *)ordersVC didSelectOrder:(OMNOrder *)order {
  [self showOrder:order];
}

- (void)ordersVCDidCancel:(OMNOrdersVC *)ordersVC {
  [self.navigationController popToViewController:self animated:YES];
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - OMNRestaurantInfoVCDelegate

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC {
  [self.navigationController popToViewController:self animated:YES];
}

@end
