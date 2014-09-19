//
//  GCalculatorVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVC.h"
#import "OMNProdductSelectionVC.h"
#import "OMNSplitSelectionVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNOrder.h"
#import "OMNNavigationBarSelector.h"
#import "OMNConstants.h"
#import "UIView+frame.h"
#import "OMNUtils.h"

static const NSTimeInterval kSlideAnimationDuration = 0.25;
const CGFloat kCalculatorTopOffset = 40.0f;

@interface OMNCalculatorVC ()
<OMNCalculatorVCDelegate>

@property (strong, nonatomic) OMNProdductSelectionVC *firstViewController;
@property (strong, nonatomic) OMNSplitSelectionVC *secondViewController;

@property (nonatomic, weak) UIViewController *currentController;

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation OMNCalculatorVC {
  OMNOrder *_order;
  UIButton *_totalButton;
  long long _total;
}

- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  OMNNavigationBarSelector *_navSelector = [[OMNNavigationBarSelector alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), kCalculatorTopOffset) titles:
                                            @[
                                              NSLocalizedString(@"По блюдам", nil),
                                              NSLocalizedString(@"Поровну", nil)
                                              ]];
  [self.view addSubview:_navSelector];
  [_navSelector addTarget:self action:@selector(navSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
  
  _totalButton = [[UIButton alloc] init];
  [_totalButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_totalButton setBackgroundImage:[UIImage imageNamed:@"button_green"] forState:UIControlStateNormal];
  [_totalButton addTarget:self action:@selector(totalTap) forControlEvents:UIControlEventTouchUpInside];
  [_totalButton sizeToFit];
  
  [self.view addSubview:_totalButton];
  
  _containerView = [[UIView alloc] init];
  [self.view addSubview:_containerView];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    if ([self.delegate respondsToSelector:@selector(calculatorVCDidCancel:)]) {
      [self.delegate calculatorVCDidCancel:self];
    }
    
  }];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  __weak typeof(self)weakSelf = self;
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    [weakSelf totalTap];
    
  }];
  self.navigationItem.rightBarButtonItem.tintColor = ([UIColor colorWithRed:2 / 255. green:193 / 255. blue:100 / 255. alpha:1]);
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  self.transitionInProgress = NO;
  
  self.currentController = self.firstViewController;
  
  // If this is the very first time we're loading this we need to do
  // an initial load and not a swap.
  [self addChildViewController:self.firstViewController];
  self.firstViewController.view.frame = _containerView.bounds;
  [_containerView addSubview:self.firstViewController.view];
  [self.firstViewController didMoveToParentViewController:self];
  
  [self.view bringSubviewToFront:_totalButton];
  
  [self totalDidChange:_order.selectedItemsTotal];
  
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
    splitType = kSplitTypeNumberOfGuersts;
  }
  
  [self.delegate calculatorVC:self splitType:splitType didFinishWithTotal:_total];
  
}

- (void)viewWillLayoutSubviews {
  
  [super viewWillLayoutSubviews];
  CGRect toFrame = self.view.bounds;
  toFrame.origin.y = kCalculatorTopOffset;
  toFrame.size.height -= kCalculatorTopOffset;
  _containerView.frame = toFrame;
  
  _totalButton.bottom = self.view.height - 11.0f;
  _totalButton.x = self.view.width * 0.5f;
  
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"white_pixel"];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.navigationController.navigationBar.shadowImage = nil;
}

- (void)navSelectorDidChange:(OMNNavigationBarSelector *)navSelector {
  
  [self showViewControllerAtIndex:navSelector.selectedIndex];
  
}

- (OMNProdductSelectionVC *)firstViewController {
  
  if (nil == _firstViewController) {
    
    _firstViewController = [[OMNProdductSelectionVC alloc] initWithOrder:_order];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 60.0f, 0);
    _firstViewController.tableView.contentInset = insets;
    _firstViewController.tableView.scrollIndicatorInsets = insets;
    _firstViewController.delegate = self;
  }
  return _firstViewController;
  
}

- (OMNSplitSelectionVC *)secondViewController {
  
  if (nil == _secondViewController) {
    
    long long total = [_order totalAmount];
    _secondViewController = [[OMNSplitSelectionVC alloc] initWIthTotal:total];
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

- (void)totalDidChange:(long long)total {
  
  _total = total;
  [UIView animateWithDuration:0.3 animations:^{

    if (_total > 0) {
      _totalButton.alpha = 1.0f;
      [_totalButton setTitle:[OMNUtils commaStringFromKop:total] forState:UIControlStateNormal];
    }
    else {
      _totalButton.alpha = 0.0f;
    }
    
  }];
  
}

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {  
}

@end
