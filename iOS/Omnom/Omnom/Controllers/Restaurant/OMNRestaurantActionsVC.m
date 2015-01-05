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

@interface OMNRestaurantActionsVC()

@end

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;
  NSString *_waiterCallIdentifier;
  
}

- (void)dealloc {
  
  @try {
    
    [_restaurantMediator removeObserver:self forKeyPath:NSStringFromSelector(@selector(waiterIsCalled))];
    
  }
  @catch (NSException *exception) {}
  
  
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
  
  [_restaurantMediator addObserver:self forKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_restaurantMediator] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(waiterIsCalled))]) {
    
    [self updateRestaurantActionButtons];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
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
  
  [_restaurantMediator checkTableAndOrders];
  
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
#warning updateRestaurantActionButtons
  [self addActionBoardIfNeeded];
  UIButton *callBillButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"bill_icon_small"] title:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт")];
  [callBillButton addTarget:_restaurantMediator action:@selector(callBillAction:) forControlEvents:UIControlEventTouchUpInside];
  
  self.bottomToolbar.hidden = NO;
  
  if (_restaurantMediator.restaurant.settings.has_waiter_call) {
    
    UIImage *callWaiterImage = [UIImage imageNamed:@"call_waiter_icon_small"];
    OMNToolbarButton *callWaiterButton = [[OMNToolbarButton alloc] initWithImage:callWaiterImage title:NSLocalizedString(@"WAITER_CALL_BUTTON_TITLE", @"Официант")];
    [callWaiterButton addTarget:_restaurantMediator action:@selector(callWaiterAction:) forControlEvents:UIControlEventTouchUpInside];
    [callWaiterButton sizeToFit];
    
    self.bottomToolbar.items =
    @[
      [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
      ];
    
  }
  else {
    
    self.bottomToolbar.items =
    @[
      [UIBarButtonItem omn_flexibleItem],
      [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
      [UIBarButtonItem omn_flexibleItem],
      ];
    
  }
  
}

- (void)setWaiterCancelButtons {
  
  OMNToolbarButton *cancelWaiterButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"WAITER_CALL_CANCEL_BUTTON_TITLE", @"Отменить вызов")];
  [cancelWaiterButton addTarget:self action:@selector(cancelWaiterCallTap) forControlEvents:UIControlEventTouchUpInside];
  [cancelWaiterButton sizeToFit];
  self.bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:cancelWaiterButton],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
}

- (void)callWaiterDidStart {
  
  [self setWaiterCancelButtons];
  
}

- (void)setLoadingState {
  
  self.bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [UIBarButtonItem omn_loadingItem],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
}

- (void)cancelWaiterCallTap {
  
  [self setLoadingState];

#warning 123
//  __weak typeof(self)weakSelf = self;
//  [_visitor waiterCallStopWithFailure:^(NSError *error) {
//    
//    if (error) {
//      [weakSelf setWaiterCancelButtons];
//    }
//    
//  }];
  
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
