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
#import "OMNToolbarButton.h"
#import "OMNSocketManager.h"
#import "OMNDecodeBeacon.h"

@interface OMNR1VC ()
<OMNPayOrderVCDelegate,
OMNOrdersVCDelegate,
OMNUserInfoVCDelegate,
OMNRestaurantInfoVCDelegate>

@end

@implementation OMNR1VC {
  OMNRestaurant *_restaurant;
  OMNDecodeBeacon *_decodeBeacon;
  UIButton *_callWaiterButton;
}

- (instancetype)initWithDecodeBeacon:(OMNDecodeBeacon *)decodeBeacon {
  self = [super initWithParent:nil];
  if (self) {
    _decodeBeacon = decodeBeacon;
    _restaurant = decodeBeacon.restaurant;
    self.circleIcon = _restaurant.logo;
    //    _productsModel = [[OMNProductsModel alloc] init];
    //    _restaurantMenuMediator = [[OMNRestaurantMenuMediator alloc] initWithRootViewController:self];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(userProfileTap)];
  self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
  
  if (_decodeBeacon.demo) {

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    
  }
  
  self.backgroundImage = _restaurant.background;
  self.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:_restaurant.background_color];

  [self addActionsBoard];
  
  [self socketConnect];
  
}

- (void)cancelTap {
  
  [self.delegate r1VCDidFinish:self];
  
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
  
  [self addBottomButtons];
  
  _callWaiterButton = [[OMNToolbarButton alloc] init];
  [_callWaiterButton setImage:[UIImage imageNamed:@"call_waiter_icon_small"] forState:UIControlStateNormal];
  [_callWaiterButton setTitle:NSLocalizedString(@"Официант", nil) forState:UIControlStateNormal];
  
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Отменить\nвызов", nil)];
  NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
  style.lineSpacing = 0.0f;
  style.maximumLineHeight = 20.0f;
  [attrString addAttribute:NSParagraphStyleAttributeName
                     value:style
                     range:NSMakeRange(0, attrString.length)];
  [_callWaiterButton setAttributedTitle:attrString forState:UIControlStateSelected];
  [_callWaiterButton setAttributedTitle:attrString forState:UIControlStateSelected|UIControlStateHighlighted];
  
  [_callWaiterButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
  [_callWaiterButton sizeToFit];
  
  UIButton *callBillButton = [[OMNToolbarButton alloc] init];
  [callBillButton setImage:[UIImage imageNamed:@"call_bill_icon_small"] forState:UIControlStateNormal];
  [callBillButton setTitle:NSLocalizedString(@"Счет", nil) forState:UIControlStateNormal];
  [callBillButton addTarget:self action:@selector(callBillTap) forControlEvents:UIControlEventTouchUpInside];
  [callBillButton sizeToFit];

  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:_callWaiterButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
    ];
  
  UIButton *actionButton = [[UIButton alloc] init];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  [actionButton addTarget:self action:@selector(showInfoTap) forControlEvents:UIControlEventTouchUpInside];
  UIImage *backgroundImage = [[UIImage imageNamed:@"circle_bg_small"] omn_tintWithColor:_restaurant.background_color];
  [actionButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [actionButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
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
  self.bottomViewConstraint.constant = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (void)showInfoTap {
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithRestaurant:_restaurant];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
  
}

- (void)callWaiterStop {
  
  __weak typeof(self)weakSelf = self;
  [_restaurant waiterCallStopCompletion:^{
    
    [weakSelf callWaiterDidStop];
    
  } failure:^(NSError *error) {
    
    NSLog(@"waiterCallStopError>%@", error);
    
  }];
  
}

- (void)callWaiterDone {
  
  _callWaiterButton.selected = YES;
  [_callWaiterButton sizeToFit];
  [self.circleButton setImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"] forState:UIControlStateNormal];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)callWaiterDidStop {
  
  [self.circleButton setImage:_restaurant.logo forState:UIControlStateNormal];
  _callWaiterButton.selected = NO;
  [_callWaiterButton sizeToFit];

}

- (void)callWaiterTap {
  
  if (_restaurant.waiterCallTableID) {
    
    [self callWaiterStop];
    return;

  }
  
  UIImage *logo = _restaurant.logo;
  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  [self searchBeaconWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [restaurant waiterCallForTableID:decodeBeacon.table_id completion:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          [weakSelf callWaiterDone];
          
        }];
        
      });
      
    } failure:^(NSError *error) {
      
      NSLog(@"callWaiterTap>%@", error);
      
    } stop:^{
      
      [weakSelf callWaiterDidStop];
      
    }];
    
  } cancelBlock:^{
    
    _callWaiterButton.selected = NO;
    [self.circleButton setImage:logo forState:UIControlStateNormal];
    [self.navigationController popToViewController:self animated:YES];
    
  }];
  
}

- (void)callBillTap {

  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  [self searchBeaconWithIcon:[UIImage imageNamed:@"bill_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon) {
    
    [restaurant getOrdersForTableID:decodeBeacon.table_id orders:^(NSArray *orders) {
      
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
  
}

- (void)searchBeaconWithIcon:(UIImage *)icon completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock {
  
  OMNSearchBeaconVC *searchBeaconVC = [[OMNSearchBeaconVC alloc] initWithParent:self completion:completionBlock cancelBlock:cancelBlock];
  searchBeaconVC.estimateAnimationDuration = 2.0;
  searchBeaconVC.circleIcon = icon;
  if (_decodeBeacon.demo) {
    searchBeaconVC.uuid = _decodeBeacon.uuid;
  }
  [self.navigationController pushViewController:searchBeaconVC animated:YES];
  
}

- (void)checkPushNotificationForOrders:(NSArray *)orders {
  
  if ([OMNAuthorisation authorisation].pushNotificationsRequested) {
    
    [self processOrders:orders];
    
  }
  else {

    if (!_decodeBeacon.demo &&
        orders.count &&
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
  
  __weak typeof(self)weakSelf = self;
  didFailOmnomVC.buttonInfo =
  @[
    @{
      @"title" : NSLocalizedString(@"Ок", nil),
      @"block" : ^{
        
        [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        
      },
      }
    ];

  [self.navigationController pushViewController:didFailOmnomVC animated:YES];
  
}

- (void)showOrder:(OMNOrder *)order {
  
  OMNPayOrderVC *paymentVC = [[OMNPayOrderVC alloc] initWithDecodeBeacon:_decodeBeacon order:order];
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

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - OMNPayOrderVCDelegate

- (void)payOrderVCDidFinish:(OMNPayOrderVC *)payOrderVC {
  
  if (_decodeBeacon.demo) {
    [self.delegate r1VCDidFinish:self];
  }
  else {
    [self.navigationController popToViewController:self animated:YES];
  }
  
}

- (void)payOrderVCDidCancel:(OMNPayOrderVC *)payOrderVC {
  [self.navigationController popToViewController:self animated:YES];
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
