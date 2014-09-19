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
#import "OMNSocketManager.h"
#import "UIImage+omn_helper.h"
#import "OMNPushPermissionVC.h"
#import "OMNToolbarButton.h"
#import "OMNSocketManager.h"
#import "OMNVisitor.h"
#import "OMNRestaurantMediator.h"
#import "OMNLightBackgroundButton.h"
#import "OMNImageManager.h"

@interface OMNR1VC ()

@end

@implementation OMNR1VC {
  OMNRestaurant *_restaurant;
  OMNToolbarButton *_callWaiterButton;
  
  UIImageView *_iv1;
  UIImageView *_iv2;
  UIImageView *_iv3;
  NSTimer *_circleAnimationTimer;
  
  UIButton *_placeholderCircleButton;
  OMNRestaurantMediator *_restaurantMediator;
}

- (void)dealloc {
  @try {
    [_restaurant removeObserver:self forKeyPath:NSStringFromSelector(@selector(background))];
  }
  @catch (NSException *exception) {
  }
  [[OMNSocketManager manager] disconnect];
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super initWithParent:nil];
  if (self) {
    _visitor = visitor;
    _restaurant = visitor.restaurant;
    self.circleIcon = _restaurant.logo;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
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
  
  self.backgroundImage = _restaurant.background;
  self.circleBackground = _restaurant.circleBackground;
  
  [self addActionsBoard];
  [self socketConnect];

  __weak typeof(self)weakSelf = self;
  [_restaurant loadBackgroundBlurred:NO completion:^(UIImage *image) {
    
    if (image) {
      [weakSelf setBackgroundImage:image animated:YES];
    }
    
  }];
  
}

- (void)beginCircleAnimationIfNeeded {

  if (NO == _callWaiterButton.selected) {
    return;
  }
  
  _iv1 = [[UIImageView alloc] initWithImage:self.circleBackground];
  _iv1.center = self.circleButton.center;
  [self.backgroundView addSubview:_iv1];

  _iv2 = [[UIImageView alloc] initWithImage:self.circleBackground];
  _iv2.alpha = 0.5f;
  _iv2.center = self.circleButton.center;
  [self.backgroundView addSubview:_iv2];

  _iv3 = [[UIImageView alloc] initWithImage:self.circleBackground];
  _iv3.alpha = 0.25f;
  _iv3.center = self.circleButton.center;
  [self.backgroundView addSubview:_iv3];
  
  [_circleAnimationTimer invalidate];
  
  CGFloat animationRepeatCount = 3.0f;

  NSTimeInterval duration = 2.5;
  NSTimeInterval delay = 0.0f;
  NSTimeInterval animationPause = 3.0;
  NSTimeInterval totalAnimationCicleDuration = duration*animationRepeatCount + animationPause;
  _circleAnimationTimer = [NSTimer bk_scheduledTimerWithTimeInterval:totalAnimationCicleDuration block:^(NSTimer *timer) {
    
    [UIView transitionWithView:_iv1 duration:duration/2. options:UIViewAnimationOptionAutoreverse animations:^{
      
      [UIView setAnimationRepeatCount:animationRepeatCount - 0.5f];
      _iv1.transform = CGAffineTransformMakeScale(1.2f, 1.2f);

    } completion:^(BOOL finished) {
      
      [UIView animateWithDuration:duration/2. animations:^{
        _iv1.transform = CGAffineTransformIdentity;
      }];

    }];
    
    [UIView animateWithDuration:duration delay:delay options:0 animations:^{
      [UIView setAnimationRepeatCount:animationRepeatCount];

      _iv2.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
      _iv3.transform = CGAffineTransformMakeScale(5.0f, 5.0f);
      
      _iv2.alpha = 0.0f;
      _iv3.alpha = 0.0f;
      
    } completion:^(BOOL finished) {
      _iv2.transform = CGAffineTransformIdentity;
      _iv3.transform = CGAffineTransformIdentity;
      
      _iv2.alpha = 0.5f;
      _iv3.alpha = 0.25f;
    }];
    
  } repeats:YES];
  [_circleAnimationTimer fire];
}

- (void)finishCircleAnimation {
  
  [_circleAnimationTimer invalidate];
  _circleAnimationTimer = nil;
  
  [UIView animateWithDuration:0.50 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    
    _iv1.alpha = 0.0f;
    _iv2.alpha = 0.0f;
    _iv3.alpha = 0.0f;
    _iv1.transform = CGAffineTransformIdentity;
    _iv2.transform = CGAffineTransformIdentity;
    _iv3.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {

    [_iv1 removeFromSuperview];
    [_iv2 removeFromSuperview];
    [_iv3 removeFromSuperview];
    
  }];
  
}

- (void)cancelTap {
  
  [self.delegate r1VCDidFinish:self];
  
}

- (void)socketConnect {
  
  if (NO == _visitor.restaurant.is_demo) {
    [[OMNSocketManager manager] connectWithToken:[OMNAuthorisation authorisation].token];
  }
  
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
  UIImage *backgroundImage = [[UIImage imageNamed:@"circle_bg_small"] omn_tintWithColor:_restaurant.background_color];
  [actionButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
  [actionButton setImage:[UIImage imageNamed:@"down_button_icon"] forState:UIControlStateNormal];
  [self.view addSubview:actionButton];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:actionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.circleButton attribute:NSLayoutAttributeBottom multiplier:1.0f constant:50.0f]];
  [self.view layoutIfNeeded];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:NO];
  [self.navigationItem setHidesBackButton:YES animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self beginCircleAnimationIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self finishCircleAnimation];
}


- (void)callWaiterStop {
  
  [_restaurant waiterCallStopCompletion:^{
    
  } failure:^(NSError *error) {
    
    NSLog(@"waiterCallStopError>%@", error);
    
  }];
  
}

- (void)callWaiterDidStart {
  
  _placeholderCircleButton = [[UIButton alloc] initWithFrame:self.circleButton.frame];
  [_placeholderCircleButton setImage:[UIImage imageNamed:@"bell_ringing_icon_white_big"] forState:UIControlStateNormal];
  [_placeholderCircleButton setBackgroundImage:[self.circleButton backgroundImageForState:UIControlStateNormal] forState:UIControlStateNormal];
  _placeholderCircleButton.userInteractionEnabled = NO;
  [self.circleButton.superview addSubview:_placeholderCircleButton];
  
  _callWaiterButton.selected = YES;
  [_callWaiterButton sizeToFit];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)callWaiterDidStop {
  
  [self finishCircleAnimation];

  [UIView animateWithDuration:0.3 animations:^{
    _placeholderCircleButton.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [_placeholderCircleButton removeFromSuperview];
    _placeholderCircleButton = nil;
  }];
  
  _callWaiterButton.selected = NO;
  [_callWaiterButton sizeToFit];

  [self.navigationController popToViewController:self animated:YES];
}

- (void)callWaiterTap {
  
  if (_restaurant.waiterCallTableID) {
    
    [self callWaiterStop];
    return;

  }
  
  OMNRestaurant *restaurant = _restaurant;
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator searchBeaconWithIcon:[UIImage imageNamed:@"bell_ringing_icon_white_big"] completion:^(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *visitor) {
  
    [restaurant waiterCallForTableID:visitor.table.id completion:^{
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [searchBeaconVC finishLoading:^{
          
          [weakSelf callWaiterDidStart];
          
        }];
        
      });
      
    } failure:^(NSError *error) {
      
      NSLog(@"callWaiterTap>%@", error);
      
    } stop:^{
      
      [weakSelf callWaiterDidStop];
      
    }];
    
  } cancelBlock:^{
    
    [weakSelf callWaiterDidStop];
    
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
