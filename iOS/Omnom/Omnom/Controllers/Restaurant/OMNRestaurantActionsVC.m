//
//  OMNBackgroundVC+restaurant.m
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantActionsVC.h"
#import "OMNRestaurantMediator.h"
#import "OMNNavigationController.h"
#import "OMNNavigationControllerDelegate.h"
#import "OMNRestaurantActionsToolbar.h"
#import <OMNStyler.h>

@implementation OMNRestaurantActionsVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNNavigationController *_navigationController;

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
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.view.backgroundColor = [UIColor whiteColor];
  
  [self setupControllers];

}

- (void)showRestaurantAnimated:(BOOL)animated {
  
  [_navigationController popToViewController:_r1VC animated:animated];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
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

- (void)setupControllers {
  
  _r1VC = [[OMNR1VC alloc] initWithMediator:_restaurantMediator];
  
  _navigationController = [[OMNNavigationController alloc] initWithRootViewController:_r1VC];
  _navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [self addChildViewController:_navigationController];
  [self.view addSubview:_navigationController.view];
  _navigationController.view.translatesAutoresizingMaskIntoConstraints = NO;
  
  OMNRestaurantActionsToolbar *toolbar = [[OMNRestaurantActionsToolbar alloc] init];
  toolbar.translatesAutoresizingMaskIntoConstraints = NO;
  toolbar.restaurantMediator = _restaurantMediator;
  [self.view addSubview:toolbar];
  
  NSDictionary *views =
  @{
    @"bottomToolbar" : toolbar,
    @"navigationController" : _navigationController.view,
    };
  
  NSDictionary *metrics =
  @{
    @"bottomToolbarHeight" : [[OMNStyler styler] bottomToolbarHeight],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationController]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bottomToolbar]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[bottomToolbar(bottomToolbarHeight)]|" options:kNilOptions metrics:metrics views:views]];
  [_navigationController didMoveToParentViewController:self];
  
}

@end
