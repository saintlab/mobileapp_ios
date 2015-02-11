//
//  OMNBackgroundVC+restaurant.m
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"
#import "OMNToolbarButton.h"
#import "OMNRestaurantMediator.h"
#import "OMNR1VC.h"
#import "OMNNavigationController.h"
#import <BlocksKit+UIKit.h>
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurantManager.h"
#import "OMNTable+omn_network.h"
#import "OMNMyOrderButton.h"
#import "UIButton+omn_helper.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNUtils.h"

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;
  NSString *_restaurantWaiterCallIdentifier;

}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  if (_restaurantWaiterCallIdentifier) {
    [_restaurantMediator bk_removeObserversWithIdentifier:_restaurantWaiterCallIdentifier];
  }
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurantMediator = [[OMNRestaurantMediator alloc] initWithRestaurant:restaurant rootViewController:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.opaque = YES;
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupControllers];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateRestaurantActionButtons) name:OMNRestaurantOrdersDidChangeNotification object:nil];
  
  __weak typeof(self)weakSelf = self;
  _restaurantWaiterCallIdentifier = [_restaurantMediator bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNRestaurantMediator *obj, NSDictionary *change) {
    
    [weakSelf updateRestaurantActionButtons];
    
  }];

}

- (void)showRestaurantAnimated:(BOOL)animated {
  
  [_navigationController popToViewController:_r1VC animated:animated];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [_restaurantMediator checkOrders];
  
}

- (UIViewController *)childViewControllerForStatusBarHidden {
  
  UIViewController *visibleViewController = _navigationController.childViewControllerForStatusBarHidden;
  return visibleViewController;
  
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  
  UIViewController *visibleViewController = _navigationController.childViewControllerForStatusBarStyle;
  return visibleViewController;
  
}

- (void)updateRestaurantActionButtons {

  [self addActionBoardIfNeeded];
  self.bottomToolbar.hidden = NO;
  
  UIButton *callBillButton = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"bill_icon_small"] color:[UIColor blackColor] target:_restaurantMediator action:@selector(callBill)];
  UIButton *callWaiterButton = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"call_waiter_icon_small"] color:[UIColor blackColor] target:_restaurantMediator action:@selector(callWaiterTap)];
  
  OMNRestaurantSettings *settings = _restaurantMediator.restaurant.settings;
  if (settings.has_menu) {
    
    callWaiterButton.hidden = !settings.has_waiter_call;

    OMNMyOrderButton *myOrderButton = [[OMNMyOrderButton alloc] initWithRestaurantMediator:_restaurantMediator];
    
    [self.bottomToolbar setItems:
     @[
       [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
       [UIBarButtonItem omn_flexibleItem],
       [[UIBarButtonItem alloc] initWithCustomView:myOrderButton],
       [UIBarButtonItem omn_flexibleItem],
       [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
       ]
                        animated:YES];
    
  }
  else if (_restaurantMediator.restaurant.settings.has_waiter_call) {
    
    [callBillButton setTitle:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт") forState:UIControlStateNormal];
    [callBillButton omn_centerButtonAndImageWithSpacing:4.0f];
    [callBillButton sizeToFit];
    
    [callWaiterButton setTitle:NSLocalizedString(@"WAITER_CALL_BUTTON_TITLE", @"Официант") forState:UIControlStateNormal];
    [callWaiterButton omn_centerButtonAndImageWithSpacing:4.0f];
    [callWaiterButton sizeToFit];
    
    if (_restaurantMediator.waiterIsCalled) {
      
      [self setWaiterCancelButtons];
      
    }
    else {
      
      [self.bottomToolbar setItems:
       @[
         [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
         [UIBarButtonItem omn_flexibleItem],
         [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
         ]
                          animated:YES];
      
    }
    
  }
  else {
    
    [callBillButton setTitle:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт") forState:UIControlStateNormal];
    [callBillButton omn_centerButtonAndImageWithSpacing:4.0f];
    [callBillButton sizeToFit];
    
    [self.bottomToolbar setItems:
     @[
       [UIBarButtonItem omn_flexibleItem],
       [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
       [UIBarButtonItem omn_flexibleItem],
       ]
                        animated:YES];
    
  }
  
  
  
}

- (void)setWaiterCancelButtons {
  
  OMNToolbarButton *cancelWaiterButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"WAITER_CALL_CANCEL_BUTTON_TITLE", @"Отменить вызов")];
  [cancelWaiterButton addTarget:self action:@selector(cancelWaiterCallTap) forControlEvents:UIControlEventTouchUpInside];
  [cancelWaiterButton sizeToFit];
  
  [self.bottomToolbar setItems:
   @[
     [UIBarButtonItem omn_flexibleItem],
     [[UIBarButtonItem alloc] initWithCustomView:cancelWaiterButton],
     [UIBarButtonItem omn_flexibleItem],
     ]
                      animated:YES];
  
}

- (void)setLoadingState {
  
  [self.bottomToolbar setItems:
   @[
     [UIBarButtonItem omn_flexibleItem],
     [UIBarButtonItem omn_loadingItem],
     [UIBarButtonItem omn_flexibleItem],
     ]
                      animated:YES];
  
}

- (void)callWaiterTap {
  
  [self setLoadingState];
  [_restaurantMediator waiterCallWithCompletion:^{
  }];
  
}

- (void)cancelWaiterCallTap {
  
  [self setLoadingState];
  [_restaurantMediator waiterCallStopWithCompletion:^{
  }];
  
}

- (void)setupControllers {
  
  _r1VC = [[OMNR1VC alloc] initWithMediator:_restaurantMediator];
  
  _navigationController = [[OMNNavigationController alloc] initWithRootViewController:_r1VC];
  _navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [self addChildViewController:_navigationController];
  [self.view addSubview:_navigationController.view];
  _navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSDictionary *views =
  @{
    @"navigationController" : _navigationController.view,
    };
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationController]|" options:kNilOptions metrics:nil views:views]];
  
  [_navigationController didMoveToParentViewController:self];
  
}

@end
