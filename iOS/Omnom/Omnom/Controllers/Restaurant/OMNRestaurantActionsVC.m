//
//  OMNBackgroundVC+restaurant.m
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"
#import "OMNNavigationController.h"
#import "OMNRestaurantActionsToolbar.h"
#import <OMNStyler.h>
#import "OMNVisitor.h"

@interface OMNRestaurantActionsVC ()

@property (nonatomic, strong, readonly) OMNRestaurantActionsToolbar *restaurantActionsToolbar;

@end

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
  
  _internalNVC = [OMNNavigationController controllerWithRootVC:_r1VC];
  [_internalNVC willMoveToParentViewController:self];
  [self.view addSubview:_internalNVC.view];
  [self addChildViewController:_internalNVC];
  _internalNVC.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  _restaurantActionsToolbar = [[OMNRestaurantActionsToolbar alloc] init];
  _restaurantActionsToolbar.translatesAutoresizingMaskIntoConstraints = NO;
  _restaurantActionsToolbar.restaurantMediator = _restaurantMediator;
  [self.view addSubview:_restaurantActionsToolbar];
  
  NSDictionary *views =
  @{
    @"bottomToolbar" : _restaurantActionsToolbar,
    @"navigationController" : _internalNVC.view,
    };
  
  NSDictionary *metrics =
  @{
    @"bottomToolbarHeight" : @(OMNStyler.bottomToolbarHeight),
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomToolbar]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(bottomToolbarHeight)]|" options:kNilOptions metrics:metrics views:views]];
  [_internalNVC didMoveToParentViewController:self];
  
}

@end
