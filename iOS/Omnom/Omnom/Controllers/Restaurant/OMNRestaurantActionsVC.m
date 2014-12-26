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
#import "OMNVisitor+network.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNRestaurantActionsVC()

@property (nonatomic, strong) OMNVisitor *visitor;

@end

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;
  NSString *_waiterCallIdentifier;
  
}

- (void)removeWaiterCallObserver {
  
  if (_waiterCallIdentifier) {
    [_visitor bk_removeObserversWithIdentifier:_waiterCallIdentifier];
    _waiterCallIdentifier = nil;
  }
  
}

- (void)dealloc {
  
  [self removeWaiterCallObserver];
  
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    self.visitor = visitor;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.opaque = YES;
  self.view.backgroundColor = [UIColor whiteColor];
  
  _restaurantMediator = [[OMNRestaurantMediator alloc] initWithRootViewController:self];
  _r1VC = [[OMNR1VC alloc] initWithMediator:_restaurantMediator];
  
  _navigationController  = [[OMNNavigationController alloc] initWithRootViewController:_r1VC];
  _navigationController.delegate = self.navigationController.delegate;
  [self addChildViewController:_navigationController];
  [self.view addSubview:_navigationController.view];
  _navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
  NSDictionary *views =
  @{
    @"navigationController" : _navigationController.view,
    };
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationController]|" options:0 metrics:nil views:views]];
  
  [_navigationController didMoveToParentViewController:self];
  
  [self setRestaurantActionButtons];
  
}

- (void)showRestaurantAnimated:(BOOL)animated {
  
  [_navigationController popToViewController:_r1VC animated:animated];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (UIViewController *)childViewControllerForStatusBarHidden {
  
  UIViewController *visibleViewController = _navigationController.childViewControllerForStatusBarHidden;
  return visibleViewController;
  
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  
  UIViewController *visibleViewController = _navigationController.childViewControllerForStatusBarStyle;
  return visibleViewController;
  
}

- (void)setVisitor:(OMNVisitor *)visitor {
  
  [self removeWaiterCallObserver];
  _visitor = visitor;
  __weak typeof(self)weakSelf = self;
  _waiterCallIdentifier = [_visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
    
    if (weakSelf.visitor.waiterIsCalled) {
      
      [weakSelf callWaiterDidStart];
      
    }
    else {
      
      [weakSelf setRestaurantActionButtons];
      
    }
    
  }];
  
}

- (void)setRestaurantActionButtons {
  
  [self addActionBoardIfNeeded];

  UIButton *callBillButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"bill_icon_small"] title:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт")];
  [callBillButton addTarget:_restaurantMediator action:@selector(callBillAction:) forControlEvents:UIControlEventTouchUpInside];
  
  self.bottomToolbar.hidden = NO;
  
  if (self.visitor.restaurant.settings.has_waiter_call) {
    
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

  __weak typeof(self)weakSelf = self;
  [_visitor waiterCallStopWithFailure:^(NSError *error) {
    
    if (error) {
      [weakSelf setWaiterCancelButtons];
    }
    
  }];
  
}

@end
