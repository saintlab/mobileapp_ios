//
//  OMNR1VC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNR1VC.h"
#import "OMNSearchVisitorVC.h"
#import "OMNPayOrderVC.h"
#import "OMNOrdersVC.h"
#import "OMNOperationManager.h"
#import "OMNAuthorisation.h"
#import <BlocksKit+UIKit.h>
#import "UIImage+omn_helper.h"
#import "OMNPushPermissionVC.h"
#import "OMNToolbarButton.h"
#import "OMNSocketManager.h"
#import "OMNVisitor+network.h"
#import "OMNLightBackgroundButton.h"
#import "OMNImageManager.h"
#import "OMNAnalitics.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNCircleAnimation.h"
#import "OMNRestaurantInfoVC.h"
#import <OMNStyler.h>
#import "OMNRestaurantMediator.h"

NSString * const kRestaurantWaiterCallIdentifier = @"kRestaurantWaiterCallIdentifier";

@interface OMNR1VC ()
<OMNRestaurantInfoVCDelegate>

@end

@implementation OMNR1VC {
  
  OMNRestaurant *_restaurant;
  OMNCircleAnimation *_circleAnimation;
  __weak OMNRestaurantMediator *_restaurantMediator;
  BOOL _viewDidAppear;
}

- (void)dealloc {
  
  _circleAnimation = nil;
  [_visitor bk_removeObserversWithIdentifier:kRestaurantWaiterCallIdentifier];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[OMNSocketManager manager] disconnectAndLeaveAllRooms:YES];
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithParent:nil];
  if (self) {
    _restaurantMediator = restaurantMediator;
    self.visitor = _restaurantMediator.visitor;
    [[OMNAnalitics analitics] logEnterRestaurant:self.visitor];
    
    _restaurant = self.visitor.restaurant;
    self.circleIcon = _restaurant.decoration.logo;

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _circleAnimation = [[OMNCircleAnimation alloc] initWithCircleButton:self.circleButton];
  _isViewVisible = YES;
  UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showRestaurantInfo)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionUp;
  [self.view addGestureRecognizer:swipeGR];
  
  if (_visitor.restaurant.is_demo) {

    OMNLightBackgroundButton *cancelButton = [[OMNLightBackgroundButton alloc] init];
    [cancelButton setTitle:NSLocalizedString(@"Выйти из Демо", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:_restaurantMediator action:@selector(exitRestaurant) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
  }
  else {
    
    UIImage *image = [[UIImage imageNamed:@"user_settings_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(showUserProfile)];
    
  }
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidPay:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];
  
  self.circleBackground = _restaurant.decoration.circleBackground;
  
  [self omn_setup];
  [self socketConnect];
  [self loadBackgroundIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  NSLog(@"viewWillAppear>%@", self.view);
  _viewDidAppear = YES;
  [self beginCircleAnimationIfNeeded];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  _viewDidAppear = NO;
  [_circleAnimation finishCircleAnimation];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (void)setVisitor:(OMNVisitor *)visitor {
  
  [_visitor bk_removeObserversWithIdentifier:kRestaurantWaiterCallIdentifier];
  _visitor = visitor;
  __weak typeof(self)weakSelf = self;
  [_visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) identifier:kRestaurantWaiterCallIdentifier options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
    
    if (weakSelf.visitor.waiterIsCalled) {
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

- (void)showUserProfile {
  
  [_restaurantMediator showUserProfile];
  
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

- (void)omn_setup {
  
  UIImageView *gradientView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"restaurant_bg_gradient"]];
  gradientView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.backgroundView addSubview:gradientView];
  
  NSDictionary *views =
  @{
    @"gradientView" : gradientView,
    };
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gradientView]|" options:0 metrics:nil views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[gradientView]|" options:0 metrics:nil views:views]];
  
  UIButton *actionButton = [[UIButton alloc] init];
  actionButton.translatesAutoresizingMaskIntoConstraints = NO;
  [actionButton addTarget:self action:@selector(showRestaurantInfo) forControlEvents:UIControlEventTouchUpInside];
  [actionButton setImage:[UIImage imageNamed:@"down_button_icon"] forState:UIControlStateNormal];
  [self.view addSubview:actionButton];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0f constant:60.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:-[OMNStyler styler].bottomToolbarHeight.floatValue]];
  [self.view layoutIfNeeded];
  
}

- (void)showRestaurantInfo {
  
  _isViewVisible = NO;
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithVisitor:self.visitor];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
  
}

- (void)beginCircleAnimationIfNeeded {
  
  if (_visitor.waiterIsCalled &&
      _viewDidAppear) {
    [_circleAnimation beginCircleAnimationIfNeededWithImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"]];
  }
  
}

- (void)callWaiterDidStart {
  
  [self beginCircleAnimationIfNeeded];
  
}

- (void)callWaiterDidStop {
  
  [_circleAnimation finishCircleAnimation];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - OMNRestaurantInfoVCDelegate

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC {
  
  [self.navigationController popToViewController:self animated:YES];
  _isViewVisible = YES;
  
}

- (void)restaurantInfoVCShowUserInfo:(OMNRestaurantInfoVC *)restaurantInfoVC {
  
  [self showUserProfile];
  
}

@end
