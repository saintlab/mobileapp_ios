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

@interface OMNRestaurantActionsVC()

@end

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;
  NSString *_restaurantWaiterCallIdentifier;
  
}

- (void)dealloc {
  
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
  
  UIButton *callBillButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"bill_icon_small"] title:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт")];
  [callBillButton addTarget:_restaurantMediator action:@selector(callBill) forControlEvents:UIControlEventTouchUpInside];
  
  if (_restaurantMediator.restaurant.settings.has_waiter_call) {
    
    if (_restaurantMediator.waiterIsCalled) {
      
      [self setWaiterCancelButtons];
      
    }
    else {
      
      UIImage *callWaiterImage = [UIImage imageNamed:@"call_waiter_icon_small"];
      OMNToolbarButton *callWaiterButton = [[OMNToolbarButton alloc] initWithImage:callWaiterImage title:NSLocalizedString(@"WAITER_CALL_BUTTON_TITLE", @"Официант")];
      [callWaiterButton addTarget:self action:@selector(callWaiterTap) forControlEvents:UIControlEventTouchUpInside];
      [callWaiterButton sizeToFit];
      
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
  _navigationController.delegate = self.navigationController.delegate;
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
