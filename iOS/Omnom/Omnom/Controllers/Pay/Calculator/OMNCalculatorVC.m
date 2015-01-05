//
//  GCalculatorVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVC.h"
#import "OMNProductSelectionVC.h"
#import "OMNSplitSelectionVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNOrder.h"
#import "OMNNavigationBarSelector.h"
#import "OMNConstants.h"
#import "UIView+frame.h"
#import "OMNUtils.h"
#import "UIBarButtonItem+omn_custom.h"

static const NSTimeInterval kSlideAnimationDuration = 0.25;
const CGFloat kCalculatorTopOffset = 40.0f;

@interface OMNCalculatorVC ()
<OMNCalculatorVCDelegate>

@property (strong, nonatomic) OMNProductSelectionVC *firstViewController;
@property (strong, nonatomic) OMNSplitSelectionVC *secondViewController;

@property (nonatomic, weak) UIViewController *currentController;

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation OMNCalculatorVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  UIView *_fadeView;
  UIButton *_totalButton;
  long long _total;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = NSLocalizedString(@"CALCULATOR_TITLE", @"Разделить счёт");
  
  OMNNavigationBarSelector *navSelector = [[OMNNavigationBarSelector alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), kCalculatorTopOffset) titles:
                                           @[
                                             NSLocalizedString(@"CALCULATOR_ORDER_SELECTION_BUTTON_TITLE", @"По блюдам"),
                                             NSLocalizedString(@"CALCULATOR_SPLIT_SELECTION_BUTTON_TITLE", @"Поровну")
                                             ]];
  [navSelector addTarget:self action:@selector(navSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
  [navSelector setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_gray_bg"]]];
  [self.view addSubview:navSelector];
  
  _fadeView = [[UIView alloc] init];
  _fadeView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  _fadeView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_fadeView];
  
  _totalButton = [[UIButton alloc] init];
  _totalButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_totalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _totalButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_totalButton setBackgroundImage:[UIImage imageNamed:@"button_green"] forState:UIControlStateNormal];
  [_totalButton addTarget:self action:@selector(totalTap) forControlEvents:UIControlEventTouchUpInside];
  [_fadeView addSubview:_totalButton];
  
  NSDictionary *views =
  @{
    @"fadeView" : _fadeView,
    @"totalButton" : _totalButton,
    };
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[fadeView(60)]|" options:0 metrics:nil views:views]];
  [_fadeView addConstraint:[NSLayoutConstraint constraintWithItem:_totalButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_fadeView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_fadeView addConstraint:[NSLayoutConstraint constraintWithItem:_totalButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_fadeView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  _containerView = [[UIView alloc] init];
  [self.view addSubview:_containerView];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  
  self.transitionInProgress = NO;
  
  // If this is the very first time we're loading this we need to do
  // an initial load and not a swap.
  self.currentController = self.firstViewController;
  [self addChildViewController:self.firstViewController];
  self.firstViewController.view.frame = _containerView.bounds;
  [_containerView addSubview:self.firstViewController.view];
  [self.firstViewController didMoveToParentViewController:self];
  [self.view bringSubviewToFront:_fadeView];
  
#warning totalDidChange
//  [self totalDidChange:_order.selectedItemsTotal showPaymentButton:_order.hasSelectedItems];
  
}

- (void)closeTap {
  
#warning closeTap
//  NSSet *changedOrderItemsIDs = [self.firstViewController.changedOrderItemsIDs copy];
//  [_order.guests enumerateObjectsUsingBlock:^(OMNGuest *guest, NSUInteger idx, BOOL *stop) {
//    
//    [guest.items enumerateObjectsUsingBlock:^(OMNOrderItem *orderItem, NSUInteger idx, BOOL *stop) {
//      
//      if ([changedOrderItemsIDs containsObject:orderItem.uid]) {
//        
//        orderItem.selected = !orderItem.selected;
//        
//      }
//      
//    }];
//    
//  }];
  
  [self.delegate calculatorVCDidCancel:self];
  
}

- (UITableView *)splitTableView {
  
  return self.firstViewController.tableView;
  
}

- (void)totalTap {
  
  if (0ll == _total) {
    
    [self.delegate calculatorVCDidCancel:self];
    return;
    
  }
  
  SplitType splitType = kSplitTypeNone;
  
  if ([[self.childViewControllers objectAtIndex:0] isEqual:self.firstViewController]) {
    
    splitType = kSplitTypeOrders;
    
  }
  else if ([[self.childViewControllers objectAtIndex:0] isEqual:self.secondViewController]) {
    
    splitType = kSplitTypeNumberOfGuests;
    
  }
  
  [self.delegate calculatorVC:self splitType:splitType didFinishWithTotal:_total];
  
}

- (void)viewWillLayoutSubviews {
  
  [super viewWillLayoutSubviews];
  CGRect toFrame = self.view.bounds;
  toFrame.origin.y = kCalculatorTopOffset;
  toFrame.size.height -= kCalculatorTopOffset;
  _containerView.frame = toFrame;
  
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"nav_gray_bg"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.navigationController.navigationBar.shadowImage = nil;
}

- (void)navSelectorDidChange:(OMNNavigationBarSelector *)navSelector {
  
  [self showViewControllerAtIndex:navSelector.selectedIndex];
  
}

- (OMNProductSelectionVC *)firstViewController {
  
  if (nil == _firstViewController) {
    
    _firstViewController = [[OMNProductSelectionVC alloc] initWithMediator:_restaurantMediator];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 60.0f, 0);
    _firstViewController.tableView.contentInset = insets;
    _firstViewController.tableView.scrollIndicatorInsets = insets;
    _firstViewController.delegate = self;
  }
  return _firstViewController;
  
}

- (OMNSplitSelectionVC *)secondViewController {
  
  if (nil == _secondViewController) {
    
    _secondViewController = [[OMNSplitSelectionVC alloc] initWithMediator:_restaurantMediator];
    _secondViewController.delegate = self;
    
  }
  return _secondViewController;
  
}

- (void)showViewControllerAtIndex:(NSInteger)index {
  
  if (self.transitionInProgress) {
    return;
  }
  
  
  switch (index) {
    case 0: {
      
      [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.firstViewController right:YES];
      
    } break;
    case 1: {
      
      [self swapFromViewController:[self.childViewControllers objectAtIndex:0] toViewController:self.secondViewController right:NO];
      
    } break;
  }
  
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController right:(BOOL)right {
  
  self.transitionInProgress = YES;
  
  CGRect fromFrame = fromViewController.view.frame;
  CGRect toFrame = _containerView.bounds;
  
  toFrame.origin.x = (right) ? (-toFrame.size.width) : (toFrame.size.width);
  toViewController.view.frame = toFrame;
  
  CGFloat offset = (right) ? (toFrame.size.width) : (-toFrame.size.width);
  fromFrame.origin.x += offset;
  toFrame.origin.x += offset;
  
  [self addChildViewController:toViewController];
  [fromViewController willMoveToParentViewController:nil];
  
  [self transitionFromViewController:fromViewController toViewController:toViewController duration:kSlideAnimationDuration options:UIViewAnimationOptionCurveEaseInOut animations:^{
    
    fromViewController.view.frame = fromFrame;
    toViewController.view.frame = toFrame;
    
  } completion:^(BOOL finished) {
    
    [fromViewController removeFromParentViewController];
    [toViewController didMoveToParentViewController:self];
    
    [_containerView addSubview:toViewController.view];
    self.transitionInProgress = NO;
    self.currentController = toViewController;
    
  }];
}

#pragma mark - GCalculatorVCDelegate

- (void)totalDidChange:(long long)total showPaymentButton:(BOOL)showPaymentButton {
  
  _total = total;
  [UIView animateWithDuration:0.3 animations:^{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (showPaymentButton) {
      
      insets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(_fadeView.frame), 0.0f);
      _fadeView.alpha = 1.0f;
      NSString *title = [NSString stringWithFormat:@"= %@", [OMNUtils formattedMoneyStringFromKop:total]];
      [_totalButton setTitle:title forState:UIControlStateNormal];
      
    }
    else {
      
      _fadeView.alpha = 0.0f;
      
    }
    _firstViewController.tableView.scrollIndicatorInsets = insets;
    _firstViewController.tableView.contentInset = insets;
    
  }];
  
}

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
}

@end
