//
//  GCalculatorVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCalculatorVC.h"
#import "GProdductSelectionVC.h"
#import "GSplitSelectionVC.h"
#import <BlocksKit+UIKit.h>
#import "GOrder.h"
#import "GNavSelector.h"
#import "GConstants.h"
#import "UIView+frame.h"

static const NSTimeInterval kSlideAnimationDuration = 0.25;
static const CGFloat kTopOffset = 40.0f;

@interface OMNCalculatorVC ()
<GCalculatorVCDelegate>

@property (strong, nonatomic) GProdductSelectionVC *firstViewController;
@property (strong, nonatomic) GSplitSelectionVC *secondViewController;

@property (nonatomic, weak) UIViewController *currentController;

@property (assign, nonatomic) BOOL transitionInProgress;

@end

@implementation OMNCalculatorVC {
  GOrder *_order;
  UILabel *_totalLabel;
  UIView *_containerView;
  double _total;
}

- (instancetype)initWithOrder:(GOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = NO;

  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = [UIImage imageNamed:@"white_pixel"];
  
  GNavSelector *_navSelector = [[GNavSelector alloc] initTitles:@[@"По блюдам", @"Поровну"]];
  [self.view addSubview:_navSelector];
  [_navSelector addTarget:self action:@selector(navSelectorDidChange:) forControlEvents:UIControlEventValueChanged];
  
  _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44.0f)];
  _totalLabel.backgroundColor = kGreenColor;
  _totalLabel.textAlignment = NSTextAlignmentCenter;
  _totalLabel.layer.masksToBounds = YES;
  [self.view addSubview:_totalLabel];
  
  _containerView = [[UIView alloc] init];
  [self.view addSubview:_containerView];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    if ([self.delegate respondsToSelector:@selector(calculatorVCDidCancel:)]) {
      [self.delegate calculatorVCDidCancel:self];
    }
    
  }];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] bk_initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain handler:^(id sender) {
    
    if ([self.delegate respondsToSelector:@selector(calculatorVC:didFinishWithTotal:)]) {
      [self.delegate calculatorVC:self didFinishWithTotal:[self total]];
    }
    
    
  }];
  self.navigationItem.rightBarButtonItem.tintColor = kGreenColor;

  self.view.backgroundColor = [UIColor whiteColor];
  
  self.transitionInProgress = NO;

  self.currentController = self.firstViewController;

  // If this is the very first time we're loading this we need to do
  // an initial load and not a swap.
  [self addChildViewController:self.firstViewController];
  self.firstViewController.view.frame = _containerView.bounds;
  [_containerView addSubview:self.firstViewController.view];
  [self.firstViewController didMoveToParentViewController:self];
  
  [self.view bringSubviewToFront:_totalLabel];

  [self totalDidChange:0];
  
}


- (void)viewWillLayoutSubviews {

  CGRect toFrame = self.view.bounds;
  toFrame.origin.y = kTopOffset;
  toFrame.size.height -= kTopOffset;
  _containerView.frame = toFrame;
  
  _totalLabel.y = self.view.height - 30.0f;
  
}


- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)navSelectorDidChange:(GNavSelector *)navSelector {
  
  [self showViewControllerAtIndex:navSelector.selectedIndex];
  
}

- (double)total {
  
  return _total;
  
}

- (GProdductSelectionVC *)firstViewController {
  
  if (nil == _firstViewController) {
    
    _firstViewController = [[GProdductSelectionVC alloc] initWithOrder:_order];
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 60.0f, 0);
    _firstViewController.tableView.contentInset = insets;
    _firstViewController.tableView.scrollIndicatorInsets = insets;
    _firstViewController.delegate = self;
  }
  return _firstViewController;
  
}

- (GSplitSelectionVC *)secondViewController {
  
  if (nil == _secondViewController) {

    _secondViewController = [[GSplitSelectionVC alloc] initWIthTotal:[_order total]];
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

- (void)totalDidChange:(double)total {
  
  _total = total;
  _totalLabel.text = [NSString stringWithFormat:@"%.2f Р", total];
  CGPoint center = _totalLabel.center;
  [_totalLabel sizeToFit];
  _totalLabel.width += 30.0f;
  _totalLabel.height += 30.0f;
  _totalLabel.layer.cornerRadius = _totalLabel.height * 0.5f;
  _totalLabel.center = center;
}

@end
