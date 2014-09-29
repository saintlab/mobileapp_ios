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
#import <BlocksKit+UIKit.h>
#import "UIImage+omn_helper.h"
#import "OMNPushPermissionVC.h"
#import "OMNToolbarButton.h"
#import "OMNSocketManager.h"
#import "OMNVisitor.h"
#import "OMNRestaurantMediator.h"
#import "OMNLightBackgroundButton.h"
#import "OMNImageManager.h"
#import "OMNAnalitics.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNCircleAnimation.h"

@interface OMNR1VC ()

@end

@implementation OMNR1VC {
  
  NSString *_waiterCallIdentifier;
  
  OMNRestaurant *_restaurant;
  OMNToolbarButton *_callWaiterButton;
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNCircleAnimation *_circleAnimation;
}

- (void)dealloc {
  
  if (_waiterCallIdentifier) {
    _waiterCallIdentifier = nil;
    [_visitor bk_removeObserversWithIdentifier:_waiterCallIdentifier];
  }
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
  
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super initWithParent:nil];
  if (self) {
    _visitor = visitor;
    _restaurant = visitor.restaurant;
    self.circleIcon = _restaurant.decoration.logo;
    [[OMNAnalitics analitics] logEnterRestaurant:visitor];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _circleAnimation = [[OMNCircleAnimation alloc] initWithCircleButton:self.circleButton];
  
  _restaurantMediator = [[OMNRestaurantMediator alloc] initWithRootViewController:self];

  UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:_restaurantMediator action:@selector(showRestaurantInfo)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
  [self.view addGestureRecognizer:swipeGR];
  
  if (_visitor.restaurant.is_demo) {

    OMNLightBackgroundButton *cancelButton = [[OMNLightBackgroundButton alloc] init];
    [cancelButton setTitle:NSLocalizedString(@"Выйти из Демо", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
  }
  else {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_settings_icon"] style:UIBarButtonItemStylePlain target:_restaurantMediator action:@selector(showUserProfile)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidPay:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
  
  self.circleBackground = _restaurant.decoration.circleBackground;
  
  [self addActionsBoard];
  [self socketConnect];
  [self loadBackgroundIfNeeded];
  
  __weak typeof(self)weakSelf = self;
  _waiterCallIdentifier = [_visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
    
    if (_visitor.waiterIsCalled) {
      [weakSelf callWaiterDidStart];
    }
    else {
      [weakSelf callWaiterDidStop];
    }
    
  }];
  
}

- (void)loadBackgroundIfNeeded {
  
  if (_restaurant.decoration.background_image) {
    self.backgroundImage = _restaurant.decoration.background_image;
    return;
  }
  
  self.backgroundImage = _restaurant.decoration.blurred_background_image;
  __weak typeof(self)weakSelf = self;
  [_restaurant.decoration loadBackgroundBlurred:NO completion:^(UIImage *image) {
    
    if (image) {
      [weakSelf setBackgroundImage:image animated:YES];
    }
    else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf loadBackgroundIfNeeded];
      });
    }
    
  }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)cancelTap {
  
  [self.delegate restaurantVCDidFinish:self];
  
}

- (void)socketConnect {
  
  if (NO == _visitor.restaurant.is_demo) {
    
    __weak OMNVisitor *visitor = _visitor;
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorisation authorisation].token completion:^{
      
      [visitor subscribeForTableEvents];
      
    }];
  }
  
}

- (void)orderDidPay:(NSNotification *)n {
  
  id paymentData = n.userInfo[OMNPaymentDataKey];
  [OMNPaymentNotificationControl showWithPaymentData:paymentData];

}

- (void)addActionsBoard {
  
  [self addActionBoardIfNeeded];
  UIImage *callWaiterImage = [UIImage imageNamed:@"call_waiter_icon_small"];
  _callWaiterButton = [[OMNToolbarButton alloc] initWithImage:callWaiterImage title:NSLocalizedString(@"Официант", nil)];
  [_callWaiterButton setSelectedImage:callWaiterImage selectedTitle:NSLocalizedString(@"Отменить", nil)];
  [_callWaiterButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
  [_callWaiterButton sizeToFit];
  
  UIButton *callBillButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"bill_icon_small"] title:NSLocalizedString(@"Счёт", nil)];
  [callBillButton addTarget:_restaurantMediator action:@selector(callBillAction) forControlEvents:UIControlEventTouchUpInside];

  self.bottomToolbar.hidden = NO;
  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:_callWaiterButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
    ];

  UIButton *actionButton = [[UIButton alloc] init];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  [actionButton addTarget:_restaurantMediator action:@selector(showRestaurantInfo) forControlEvents:UIControlEventTouchUpInside];
  [actionButton setImage:[UIImage imageNamed:@"down_button_icon"] forState:UIControlStateNormal];
  [self.view addSubview:actionButton];
  
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomToolbar attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  [self.view layoutIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self beginCircleAnimationIfNeeded];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [_circleAnimation finishCircleAnimation];
}


- (void)callWaiterStop {
  
  [_visitor waiterCallStopWithFailure:^(NSError *error) {
    NSLog(@"waiterCallStopError>%@", error);
  }];
  
}

- (void)callWaiterDidStart {
  
  _callWaiterButton.selected = YES;
  [_callWaiterButton sizeToFit];
  
}

- (void)callWaiterDidStop {
  
  [_circleAnimation finishCircleAnimation];
  
  _callWaiterButton.selected = NO;
  [_callWaiterButton sizeToFit];

  [self.navigationController popToViewController:self animated:YES];
}

- (void)callWaiterTap {
  
  if (_visitor.waiterIsCalled) {
    [self callWaiterStop];
    return;
  }
  
  __weak OMNVisitor *v = _visitor;
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator searchBeaconWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
    
    [v waiterCallWithFailure:^(NSError *error) {
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          [weakSelf.navigationController popToViewController:weakSelf animated:YES];
          
        }];
        
      });
      
    }];
    
  } cancelBlock:^{
    
    [weakSelf callWaiterDidStop];
    
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)beginCircleAnimationIfNeeded {
  
  if (_visitor.waiterIsCalled) {
    [_circleAnimation beginCircleAnimationIfNeededWithImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"]];
  }

}

@end
