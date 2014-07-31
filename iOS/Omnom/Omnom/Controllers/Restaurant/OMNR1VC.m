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

const CGFloat kWaiterButtonsHeight = 50.0f;

@interface OMNR1VC ()
<OMNPayOrderVCDelegate,
OMNOrdersVCDelegate,
OMNUserInfoVCDelegate>

@end

@implementation OMNR1VC {
  UIButton *_callWaiterButton;
  UIButton *_callOrderButton;
  OMNRestaurant *_restaurant;
  UIView *_waiterButtonsBg;
  NSLayoutConstraint *_slideViewConstraint;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super initWithTitle:nil buttons:@[]];
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
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
  
  self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:_restaurant.background_color];
  [self.circleButton setBackgroundImage:self.circleBackground forState:UIControlStateNormal];

  self.backgroundView.image = [UIImage imageNamed:@"bg_pic"];
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

- (UIButton *)actionButtonWithAction:(SEL)action imageName:(NSString *)imageName {
  UIButton *actionButton = [[UIButton alloc] init];
  actionButton.tintColor = [UIColor blackColor];

  [actionButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  actionButton.titleLabel.numberOfLines = 0;
  actionButton.titleLabel.textAlignment = NSTextAlignmentCenter;
  [actionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [actionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [actionButton addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
  return actionButton;
}

- (void)addActionsBoard {
  
  _waiterButtonsBg = [[UIView alloc] init];
  _waiterButtonsBg.translatesAutoresizingMaskIntoConstraints = NO;
  _waiterButtonsBg.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  [self.view addSubview:_waiterButtonsBg];
  
  _callWaiterButton = [self actionButtonWithAction:@selector(callWaiterTap) imageName:@"call_waiter_icon_small"];
  [_callWaiterButton setTitle:NSLocalizedString(@"Официант", nil) forState:UIControlStateNormal];
  [_callWaiterButton setTitle:NSLocalizedString(@"Отменить вызов", nil) forState:UIControlStateSelected];
  _callWaiterButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  _callWaiterButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
  [_waiterButtonsBg addSubview:_callWaiterButton];
  
  _callOrderButton = [self actionButtonWithAction:@selector(callBillTap) imageName:@"call_bill_icon_small"];
  _callOrderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [_callOrderButton setTitle:NSLocalizedString(@"Счет", nil) forState:UIControlStateNormal];
  _callOrderButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);
  [_waiterButtonsBg addSubview:_callOrderButton];
  
  NSDictionary *views =
  @{
    @"b1": _callWaiterButton,
    @"b2": _callOrderButton,
    @"cv": _waiterButtonsBg,
    };
  
  NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b1(==b2)][b2]|"
                                                                         options:0
                                                                         metrics:nil
                                                                           views:views];
  [_waiterButtonsBg addConstraints:constraint_H];
  
  
  NSArray *constraint_V1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b1]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
  [_waiterButtonsBg addConstraints:constraint_V1];
  
  NSArray *constraint_V2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b2]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
  [_waiterButtonsBg addConstraints:constraint_V2];
  
  NSArray *constraint_CV_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:views];
  [self.view addConstraints:constraint_CV_H];
  
  _slideViewConstraint = [NSLayoutConstraint constraintWithItem:_waiterButtonsBg attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:50];
  [self.view addConstraint:_slideViewConstraint];
  
  NSArray *constraint_CV_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cv(==50)]"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views];
  [self.view addConstraints:constraint_CV_V];
  
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
  
  _slideViewConstraint.constant = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)callWaiterTap {
  
  UIImage *logo = _restaurant.logo;
  
  if (_callWaiterButton.selected) {
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    _callWaiterButton.selected = NO;
    return;
  }
  
  OMNSearchBeaconVC *sbVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [_restaurant waiterCallForTableID:decodeBeacon.tableId complition:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          _callWaiterButton.selected = YES;
          [self.circleButton setImage:[UIImage imageNamed:@"call_waiter_icon"] forState:UIControlStateNormal];
          [self.navigationController popToViewController:self animated:YES];
          
        }];
        
      });
      
    } failure:^(NSError *error) {
      
      NSLog(@"error>%@", error);
      
    }];
    
    
    
  } cancelBlock:^{
    
    _callWaiterButton.selected = NO;
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  sbVC.estimateSearchDuration = 2.0;
  sbVC.circleIcon = [UIImage imageNamed:@"call_waiter_icon"];
  sbVC.backgroundImage = self.backgroundView.image;
  [self.navigationController pushViewController:sbVC animated:YES];
  
}

- (void)checkPushNotifications {
  
  NSLog(@"%lu", (unsigned long)[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
  
  BOOL notificationPermissionRequested = [[NSUserDefaults standardUserDefaults] boolForKey:@"notificationPermissionRequested"];
  
  
  if (UIRemoteNotificationTypeNone == [[UIApplication sharedApplication] enabledRemoteNotificationTypes]) {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"notificationPermissionRequested"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [UIAlertView bk_showAlertViewWithTitle:nil message:NSLocalizedString(@"Разрешить Omnom использовать Push сообщения для отображения информации о текущем столе?", nil) cancelButtonTitle:NSLocalizedString(@"Запретить", nil) otherButtonTitles:@[NSLocalizedString(@"Разрешить", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
      
      if (buttonIndex != alertView.cancelButtonIndex) {
        
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
        
      }
      
    }];
    
  }
  
}


- (void)callBillTap {
  
//  [self checkPushNotifications];
//  return;
  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithBlock:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [restaurant getOrdersForTableID:decodeBeacon.tableId orders:^(NSArray *orders) {
      
      [searchBeaconVC finishLoading:^{
        [weakSelf processOrders:orders];
      }];
      
    } error:^(NSError *error) {
      
      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      [self.navigationController popToViewController:self animated:YES];
      
    }];
    
  } cancelBlock:^{
    
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  searchBeaconVC.estimateSearchDuration = 2.0;
  searchBeaconVC.circleIcon = [UIImage imageNamed:@"call_bill_icon"];
  searchBeaconVC.backgroundImage = self.backgroundView.image;
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
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
    [self.navigationController popToViewController:self animated:YES];
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"На этом столике нет заказов", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
  }
  
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

@end
