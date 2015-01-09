//
//  OMNR1VC.m
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNR1VC.h"
#import "OMNOrdersVC.h"
#import "OMNOperationManager.h"
#import "OMNAuthorization.h"
#import <BlocksKit+UIKit.h>
#import "UIImage+omn_helper.h"
#import "OMNPushPermissionVC.h"
#import "OMNSocketManager.h"
#import "OMNLightBackgroundButton.h"
#import "OMNImageManager.h"
#import "OMNAnalitics.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNCircleAnimation.h"
#import "OMNRestaurantInfoVC.h"
#import <OMNStyler.h>
#import "OMNRestaurantMediator.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNRestaurantManager.h"

@interface OMNR1VC ()
<OMNRestaurantInfoVCDelegate>

@end

@implementation OMNR1VC {
  
  OMNCircleAnimation *_circleAnimation;
  OMNRestaurantMediator *_restaurantMediator;
  UIPercentDrivenInteractiveTransition *_interactiveTransition;
  NSString *_restaurantWaiterCallIdentifier;
  
}

- (void)dealloc {
  
  _circleAnimation = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  @try {
    [_restaurantMediator removeObserver:self forKeyPath:NSStringFromSelector(@selector(waiterIsCalled))];
  }
  @catch (NSException *exception) {}
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithParent:nil];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (id<UIViewControllerInteractiveTransitioning>)interactiveTransitioning {
  
  return _interactiveTransition;
  
}

- (BOOL)isViewVisible {
  
  return [self.navigationController.topViewController isEqual:self];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _circleAnimation = [[OMNCircleAnimation alloc] initWithCircleButton:self.circleButton];

  self.navigationItem.title = @"";
  
  UIPanGestureRecognizer *panGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
  [self.view addGestureRecognizer:panGR];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidPay:) name:OMNSocketIOOrderDidPayNotification object:[OMNSocketManager manager]];

  [[OMNAnalitics analitics] logEnterRestaurant:_restaurantMediator.restaurant mode:kRestaurantEnterModeApplicationLaunch];
  
  [self omn_setup];
  [self loadBackgroundIfNeeded];
  [self loadIconIfNeeded];

  [_restaurantMediator addObserver:self forKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:NSKeyValueObservingOptionNew context:NULL];

  self.circleBackground = _restaurantMediator.restaurant.decoration.circleBackground;
  
}

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  
  if (_restaurantMediator.restaurant.is_demo) {
    
    OMNLightBackgroundButton *cancelButton = [[OMNLightBackgroundButton alloc] init];
    [cancelButton setTitle:NSLocalizedString(@"Выйти из Демо", nil) forState:UIControlStateNormal];
    [cancelButton addTarget:_restaurantMediator action:@selector(exitRestaurant) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    self.navigationItem.rightBarButtonItem = nil;
    
  }
  else {
    
    UIColor *color = _restaurantMediator.restaurant.decoration.antagonist_color;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:color target:_restaurantMediator action:@selector(exitRestaurant)];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"user_settings_icon"] color:color target:self action:@selector(showUserProfile)];
    
  }

  __weak typeof(self)weakSelf = self;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
  
    [weakSelf beginCircleAnimationIfNeeded];
    
  });
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [_circleAnimation finishCircleAnimation];
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)pan:(UIPanGestureRecognizer *)panGR {
  
  CGPoint translation = [panGR translationInView:panGR.view];
  CGFloat percentage = MAX(0.0f, -translation.y / panGR.view.bounds.size.height);
  CGFloat velocity = [panGR velocityInView:panGR.view].y;
  
  switch (panGR.state) {
    case UIGestureRecognizerStateBegan: {
      
      _interactiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
      [self showRestaurantInfo];
      
    } break;
    case UIGestureRecognizerStateChanged: {
      
      [_interactiveTransition updateInteractiveTransition:percentage];

      break;
    }
    case UIGestureRecognizerStateEnded: {
      
      if (percentage > 0.3f ||
          velocity < -100.0f) {
        
        [_interactiveTransition finishInteractiveTransition];
        
      }
      else {
        
        [_interactiveTransition cancelInteractiveTransition];
        
      }
      _interactiveTransition = nil;
      
    } break;
    case UIGestureRecognizerStateCancelled: {
      
      [_interactiveTransition cancelInteractiveTransition];
      _interactiveTransition = nil;
      
    } break;
    default:
      break;
  }
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_restaurantMediator] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(waiterIsCalled))]) {

    if (_restaurantMediator.waiterIsCalled) {
      
      [self callWaiterDidStart];
      
    }
    else {
      
      [self callWaiterDidStop];
      
    }
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (void)loadIconIfNeeded {

  UIImage *logo = _restaurantMediator.restaurant.decoration.logo;
  if (logo) {
    self.circleIcon = logo;
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator.restaurant.decoration loadLogo:^(UIImage *image) {
    
    if (image) {
      
      weakSelf.circleIcon = image;
      
    }
    else {
      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [weakSelf loadIconIfNeeded];
        
      });
    }
    
  }];
  
}

- (void)loadBackgroundIfNeeded {

  UIImage *background_image = _restaurantMediator.restaurant.decoration.background_image;
  if (background_image) {
    
    self.backgroundImage = background_image;
    return;
    
  }

  [self setBackgroundImage:[UIImage imageNamed:@"wood_bg"] animated:NO];
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator.restaurant.decoration loadBackground:^(UIImage *image) {
    
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

- (void)orderDidPay:(NSNotification *)n {
  
  id paymentData = n.userInfo[OMNPaymentDataKey];
  OMNPaymentDetails *paymentDetails = [[OMNPaymentDetails alloc] initWithJsonData:paymentData];
  [OMNPaymentNotificationControl showWithPaymentDetails:paymentDetails];

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
  
  OMNRestaurantInfoVC *restaurantInfoVC = [[OMNRestaurantInfoVC alloc] initWithRestaurant:_restaurantMediator.restaurant];
  restaurantInfoVC.delegate = self;
  [self.navigationController pushViewController:restaurantInfoVC animated:YES];
  
}

- (void)beginCircleAnimationIfNeeded {

  if (_restaurantMediator.waiterIsCalled &&
      [self.navigationController.topViewController isEqual:self]) {
    
    [_circleAnimation beginCircleAnimationIfNeededWithImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"]];
    
  }
  
}

- (void)callWaiterDidStart {
  
  [self beginCircleAnimationIfNeeded];
  
}

- (void)callWaiterDidStop {
  
  [_circleAnimation finishCircleAnimation];

}

#pragma mark - OMNRestaurantInfoVCDelegate

- (void)restaurantInfoVCDidFinish:(OMNRestaurantInfoVC *)restaurantInfoVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
