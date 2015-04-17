//
//  OMNBackgroundVC+restaurant.m
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"
#import "OMNNavigationController.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNRestaurantActionsToolbar.h"
#import <OMNStyler.h>
#import "OMNVisitor.h"

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_internalNVC;

}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    
    _restaurantMediator = [visitor mediatorWithRootVC:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.opaque = YES;
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupControllers];

}

- (void)showRestaurantAnimated:(BOOL)animated {
  [_internalNVC popToRootViewControllerAnimated:animated];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  OMNRestaurantMediator *mediator = _restaurantMediator;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [mediator checkStartConditions];
  });
  
}

- (UIViewController *)childViewControllerForStatusBarHidden {
  
  UIViewController *visibleViewController = _internalNVC.childViewControllerForStatusBarHidden;
  return visibleViewController;
  
}

- (UIViewController *)childViewControllerForStatusBarStyle {
  
  UIViewController *visibleViewController = _internalNVC.childViewControllerForStatusBarStyle;
  return visibleViewController;
  
}

- (void)setupControllers {
  
  _r1VC = [[OMNR1VC alloc] initWithMediator:_restaurantMediator];
  
  _internalNVC = [[OMNNavigationController alloc] initWithRootViewController:_r1VC];
  _internalNVC.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [_internalNVC willMoveToParentViewController:self];
  [self.view addSubview:_internalNVC.view];
  [self addChildViewController:_internalNVC];
  _internalNVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  OMNRestaurantActionsToolbar *toolbar = [[OMNRestaurantActionsToolbar alloc] init];
  toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  toolbar.restaurantMediator = _restaurantMediator;
  [self.view addSubview:toolbar];
  
  NSDictionary *views =
  @{
    @"bottomToolbar" : toolbar,
    @"navigationController" : _internalNVC.view,
    };
  
  NSDictionary *metrics =
  @{
    @"bottomToolbarHeight" : [[OMNStyler styler] bottomToolbarHeight],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomToolbar]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(bottomToolbarHeight)]|" options:kNilOptions metrics:metrics views:views]];
  [_internalNVC didMoveToParentViewController:self];
  
}

@end
