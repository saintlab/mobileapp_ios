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

NSString * const kWaiterCallIdentifier = @"kWaiterCallIdentifier";


@interface OMNRestaurantActionsVC()

@property (nonatomic, strong) OMNVisitor *visitor;

@end

@implementation OMNRestaurantActionsVC {
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;
}

- (void)dealloc{
  [_visitor bk_removeObserversWithIdentifier:kWaiterCallIdentifier];
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
  
  [self setWaiterCallButtons];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  [self.r1VC beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self.r1VC endAppearanceTransition];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  [self.r1VC beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self.r1VC endAppearanceTransition];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return [_navigationController preferredStatusBarStyle];
}

- (void)setVisitor:(OMNVisitor *)visitor {
  
  [_visitor bk_removeObserversWithIdentifier:kWaiterCallIdentifier];
  _visitor = visitor;
  __weak typeof(self)weakSelf = self;
  [_visitor bk_addObserverForKeyPath:NSStringFromSelector(@selector(waiterIsCalled)) identifier:kWaiterCallIdentifier options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {
    
    if (weakSelf.visitor.waiterIsCalled) {
      [weakSelf callWaiterDidStart];
    }
    else {
      [weakSelf setWaiterCallButtons];
    }
    
  }];
  
}

- (void)setWaiterCallButtons {
  
  [self addActionBoardIfNeeded];
  UIImage *callWaiterImage = [UIImage imageNamed:@"call_waiter_icon_small"];
  OMNToolbarButton *callWaiterButton = [[OMNToolbarButton alloc] initWithImage:callWaiterImage title:NSLocalizedString(@"WAITER_CALL_BUTTON_TITLE", @"Официант")];
  [callWaiterButton addTarget:_restaurantMediator action:@selector(callWaiterAction) forControlEvents:UIControlEventTouchUpInside];
  [callWaiterButton sizeToFit];

  UIButton *callBillButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"bill_icon_small"] title:NSLocalizedString(@"BILL_CALL_BUTTON_TITLE", @"Счёт")];
  [callBillButton addTarget:_restaurantMediator action:@selector(callBillAction) forControlEvents:UIControlEventTouchUpInside];
  
  self.bottomToolbar.hidden = NO;
  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithCustomView:callWaiterButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:callBillButton],
    ];
  
}

- (void)setWaiterCancelButtons {
  
  OMNToolbarButton *cancelWaiterButton = [[OMNToolbarButton alloc] initWithImage:nil title:NSLocalizedString(@"WAITER_CALL_CANCEL_BUTTON_TITLE", @"Отменить вызов")];
  [cancelWaiterButton addTarget:self action:@selector(cancelWaiterCallTap) forControlEvents:UIControlEventTouchUpInside];
  [cancelWaiterButton sizeToFit];
  self.bottomToolbar.items =
  @[
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    [[UIBarButtonItem alloc] initWithCustomView:cancelWaiterButton],
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
    ];
  
}

- (void)callWaiterDidStart {
  
  [self setWaiterCancelButtons];
  
}

- (void)cancelWaiterCallTap {
  
  [_visitor waiterCallStopWithFailure:^(NSError *error) {
    NSLog(@"waiterCallStopError>%@", error);
  }];
  
}

@end
