//
//  GCalculatorVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVC.h"
#import "OMNSplitSelectionVC.h"
#import "OMNNavigationBarSelector.h"
#import "OMNUtils.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import "OMNProductSelectionVC.h"
#import <OMNStyler.h>

static const NSTimeInterval kSlideAnimationDuration = 0.25;
const CGFloat kCalculatorTopOffset = 40.0f;

@interface OMNCalculatorVC ()
<OMNCalculatorVCDelegate>

@property (strong, nonatomic) OMNSplitSelectionVC *secondViewController;
@property (strong, nonatomic) OMNProductSelectionVC *firstViewController;

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
  self.navigationItem.title = kOMN_CALCULATOR_TITLE;
  
  
  OMNNavigationBarSelector *navSelector = [[OMNNavigationBarSelector alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), kCalculatorTopOffset) titles:
                                           @[
                                             kOMN_CALCULATOR_ORDER_SELECTION_BUTTON_TITLE,
                                             kOMN_CALCULATOR_SPLIT_SELECTION_BUTTON_TITLE
                                             ]];
  [navSelector addTarget:self action:@selector(navSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
  [navSelector setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"nav_gray_bg"]]];
  [self.view addSubview:navSelector];
  
  _fadeView = [UIView omn_autolayoutView];
  _fadeView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  _fadeView.alpha = 0.0f;
  [self.view addSubview:_fadeView];
  
  _totalButton = [UIButton omn_autolayoutView];
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
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[fadeView(60)]|" options:kNilOptions metrics:nil views:views]];
  [_fadeView addConstraint:[NSLayoutConstraint constraintWithItem:_totalButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_fadeView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [_fadeView addConstraint:[NSLayoutConstraint constraintWithItem:_totalButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_fadeView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
  _containerView = [[UIView alloc] init];
  [self.view addSubview:_containerView];
  [self updateContainerViewFrame];
  
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
  
  OMNOrder *selectedOrder = _restaurantMediator.table.selectedOrder;
  [self totalDidChange:selectedOrder.selectedItemsTotal showPaymentButton:selectedOrder.hasSelectedItems];
  
}

- (void)closeTap {
  
  @weakify(self)
  [self showViewControllerAtIndex:0 withCompletion:^{
    
    @strongify(self)
    [self.firstViewController scrollToBottomWithCompletion:^{
  
      [self.delegate calculatorVCDidCancel:self];
      
    }];
    
  }];
  
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
  
  if ([[self.childViewControllers firstObject] isEqual:self.firstViewController]) {
    
    splitType = kSplitTypeOrders;
    
  }
  else if ([[self.childViewControllers firstObject] isEqual:self.secondViewController]) {
    
    splitType = kSplitTypeNumberOfGuests;
    
  }
  [self.delegate calculatorVC:self splitType:splitType didFinishWithTotal:_total];
  
}

- (void)viewWillLayoutSubviews {
  
  [super viewWillLayoutSubviews];
  [self updateContainerViewFrame];
  
}

- (void)updateContainerViewFrame {

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
  
  [self showViewControllerAtIndex:navSelector.selectedIndex withCompletion:nil];
  
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

- (BOOL)productSelectionShown {
  
  return [self.firstViewController isEqual:self.childViewControllers.firstObject];
  
}

- (void)showViewControllerAtIndex:(NSInteger)index withCompletion:(dispatch_block_t)completionBlock {
  
  if (self.transitionInProgress) {
    return;
  }

  if ((0 == index && [self.firstViewController isEqual:self.childViewControllers.firstObject]) ||
      (1 == index && [self.secondViewController isEqual:self.childViewControllers.firstObject])) {

      if (completionBlock) {
          completionBlock();
      }

    return;
  }
  
  switch (index) {
    case 0: {
      
      [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.firstViewController right:YES withCompletion:completionBlock];
      
    } break;
    case 1: {
      
      [self swapFromViewController:[self.childViewControllers firstObject] toViewController:self.secondViewController right:NO withCompletion:completionBlock];
      
    } break;
  }
  
}

- (void)swapFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController right:(BOOL)right withCompletion:(dispatch_block_t)completionBlock {
  
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
    
    if (completionBlock) {
      completionBlock();
    }
    
  }];
}

#pragma mark - GCalculatorVCDelegate

- (void)totalDidChange:(long long)total showPaymentButton:(BOOL)showPaymentButton {
  
  _total = total;
  NSTimeInterval duration = 0.3;
  [UIView animateWithDuration:duration animations:^{
    
    UIEdgeInsets insets = UIEdgeInsetsZero;
    if (showPaymentButton) {
      
      insets = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(_fadeView.frame), 0.0f);
      _fadeView.alpha = 1.0f;
      
    }
    else {
      
      _fadeView.alpha = 0.0f;
      
    }
    _firstViewController.tableView.scrollIndicatorInsets = insets;
    _firstViewController.tableView.contentInset = insets;
    
  }];
  
  [UIView transitionWithView:_totalButton duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    NSString *title = [NSString stringWithFormat:@"= %@", [OMNUtils formattedMoneyStringFromKop:total]];
    [_totalButton setTitle:title forState:UIControlStateNormal];
    
  } completion:nil];
  
}

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [self closeTap];
  
}

@end
