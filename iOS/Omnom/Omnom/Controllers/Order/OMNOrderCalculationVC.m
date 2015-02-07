//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNCalculatorVC.h"
#import "OMNOrderPaymentVC.h"
#import "OMNNavigationController.h"
#import "OMNOrderDataSource.h"
#import "OMNOrderTableView.h"
#import "OMNOrderActionView.h"
#import "OMNOrdersVC.h"
#import "OMNOrderCalculationVC.h"
#import "OMNPaymentFooterView.h"
#import "OMNRatingVC.h"
#import "OMNSelectOrderButton.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIImage+omn_helper.h"
#import "UIView+frame.h"
#import <BlocksKit+UIKit.h>
#import <OMNStyler.h>
#import "OMNOrderAlertManager.h"
#import "UIView+omn_autolayout.h"
#import "OMNNavigationControllerDelegate.h"

@interface OMNOrderCalculationVC ()
<OMNCalculatorVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate,
OMNOrderPaymentVCDelegate,
OMNOrderTotalViewDelegate,
OMNPaymentFooterViewDelegate>

@end

@implementation OMNOrderCalculationVC {
  
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  
  UIScrollView *_scrollView;
  UIView *_scrollContentView;
  
  BOOL _beginSplitAnimation;
  BOOL _keyboardShown;

  UIView *_tableFadeView;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (void)dealloc {
  
  [OMNOrderAlertManager sharedManager].order = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
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

  self.automaticallyAdjustsScrollViewInsets = NO;
  self.view.backgroundColor = [UIColor clearColor];
  
  [self omn_setup];
  
  OMNRestaurantDecoration *decoration = _restaurantMediator.restaurant.decoration;
  self.backgroundImage = decoration.woodBackgroundImage;

  [_paymentView configureWithColor:decoration.background_color antogonistColor:decoration.antagonist_color];
  _paymentView.delegate = self;
  
  [[OMNAnalitics analitics] logBillView:_restaurantMediator.selectedOrder];

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];

  [self updateOrder];
  [OMNOrderAlertManager sharedManager].order = _restaurantMediator.selectedOrder;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(restaurantOrdersDidChange) name:OMNRestaurantOrdersDidChangeNotification object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_gray_bg"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  
}

- (void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  _beginSplitAnimation = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

  __weak typeof(self)weakSelf = self;
  [OMNOrderAlertManager sharedManager].didCloseBlock = ^{
  
    [weakSelf.delegate orderCalculationVCDidCancel:weakSelf];
    
  };
  
  [OMNOrderAlertManager sharedManager].didUpdateBlock = ^{
    
    [weakSelf updateOrder];
    
  };
  [[OMNOrderAlertManager sharedManager] checkOrderIsClosed];
  
  [self updateOrder];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleDefault;
  
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self updateScrollViewInstets];
  
}

- (void)updateScrollViewInstets {
  
  _scrollView.contentSize = _scrollContentView.frame.size;
  CGFloat topInset = MIN(0.0f, _scrollView.height - _scrollContentView.height);
  CGFloat bottomInset = 1.0f;
  _scrollView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
  
}

- (void)restaurantOrdersDidChange {
  
  [self updateTitle];
  
}

- (void)selectedOrderTap {
  
  [self.delegate orderCalculationVCRequestOrders:self];
  
}

- (void)calculatorTap {
  
  if (_beginSplitAnimation ||
      _keyboardShown) {
    return;
  }
  _beginSplitAnimation = YES;
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithMediator:_restaurantMediator];
  calculatorVC.delegate = self;
  [self.navigationController pushViewController:calculatorVC animated:YES];
  
}

- (void)cancelTap {
  
  [self.delegate orderCalculationVCDidCancel:self];
  
}

- (void)updateOrder {
  
  OMNOrder *order = _restaurantMediator.selectedOrder;
  if (order) {
    
    _paymentView.order = order;
    _dataSource.order = order;
    _dataSource.fadeNonSelectedItems = (kSplitTypeOrders == order.splitType);
    self.tableView.orderActionView.order = order;
    [self.tableView reloadData];
    [self updateTitle];

  }
  
}

- (void)updateTitle {

  self.navigationItem.titleView = nil;
  if (_restaurantMediator.orders.count > 1) {
    
    NSUInteger index = [_restaurantMediator.orders indexOfObject:_restaurantMediator.selectedOrder];
    if (NSNotFound != index) {
      
      UIButton *button = [[OMNSelectOrderButton alloc] init];
      NSString *title = [NSString stringWithFormat:NSLocalizedString(@"ORDER_NUMBER_HEADER_TITLE %ld", @"Счёт {number} \u25BC"), (long)index + 1];
      [button setTitle:title forState:UIControlStateNormal];
      [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
      [button sizeToFit];
      self.navigationItem.titleView = button;
      
    }
    
  }
  
}

- (OMNOrderTableView *)orderTableViewWithDataSource:(OMNOrderDataSource *)dataSource {
  
  OMNOrderTableView *tableView = [[OMNOrderTableView alloc] initWithFrame:_scrollContentView.bounds style:UITableViewStylePlain];
  tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds].CGPath;
  tableView.allowsSelection = NO;
  tableView.clipsToBounds = NO;
  tableView.scrollEnabled = NO;
  OMNOrderActionView *orderActionView = [[OMNOrderActionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), kOrderTableFooterHeight)];
  orderActionView.delegate = self;
  tableView.orderActionView = orderActionView;
  
  [OMNOrderDataSource registerCellsForTableView:tableView];
  
  tableView.delegate = dataSource;
  tableView.dataSource = dataSource;
  [tableView reloadData];

  [_scrollContentView addSubview:tableView];
  
  [tableView scrollRectToVisible:CGRectMake(0.0f, tableView.contentSize.height - 1.0f, 1.0f, 1.0f) animated:NO];
  return tableView;
  
}

- (void)omn_setup {
    
  _scrollView = [UIScrollView omn_autolayoutView];
  _scrollView.clipsToBounds = NO;
  _scrollView.delegate = self;
  _scrollView.backgroundColor = [UIColor clearColor];
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  _scrollContentView = [UIView omn_autolayoutView];
  _scrollContentView.backgroundColor = [UIColor clearColor];
  [_scrollView addSubview:_scrollContentView];
  
  _tableFadeView = [UIView omn_autolayoutView];
  _tableFadeView.backgroundColor = [UIColor whiteColor];
  _tableFadeView.alpha = 0.0f;
  [_scrollView addSubview:_tableFadeView];
  
  NSDictionary *views =
  @{
    @"payment" : _paymentView,
    @"scrollView" : _scrollView,
    @"tableFadeView" : _tableFadeView,
    };

  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0f constant:0.0f]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:CGRectGetHeight([UIScreen mainScreen].bounds)]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_paymentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
  [_scrollView addGestureRecognizer:swipeGR];
  
  swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
  [_scrollView addGestureRecognizer:swipeGR];
//  UIPanGestureRecognizer *tapGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//  [self.view addGestureRecognizer:tapGR];
  
  [self.view layoutIfNeeded];
  _tableFadeView.frame = _scrollContentView.frame;

  _dataSource = [[OMNOrderDataSource alloc] init];
  _dataSource.order = _restaurantMediator.selectedOrder;
  _tableView = [self orderTableViewWithDataSource:_dataSource];
  
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGR {
  
  NSInteger index = [_restaurantMediator.orders indexOfObject:_restaurantMediator.selectedOrder];
  if (NSNotFound == index) {
    return;
  }
  
  if (UISwipeGestureRecognizerDirectionRight == swipeGR.direction &&
      index > 0) {
    
    [self showOrderAtIndex:(index - 1) animationDirection:UISwipeGestureRecognizerDirectionRight];
    
  }
  else if (UISwipeGestureRecognizerDirectionLeft == swipeGR.direction &&
           index < _restaurantMediator.orders.count - 1) {
    
    [self showOrderAtIndex:(index + 1) animationDirection:UISwipeGestureRecognizerDirectionLeft];
    
  }
  
}

- (void)showOrderAtIndex:(NSInteger)index animationDirection:(UISwipeGestureRecognizerDirection)direction {
  return;
  /*
  static OMNOrderDataSource *dataSource = nil;
  dataSource = [[OMNOrderDataSource alloc] init];
  dataSource.order = _restaurantMediator.orders[index];
  
  OMNOrderTableView *tableView = [self orderTableView];
  [_scrollView addSubview:tableView];
  [dataSource registerCellsForTableView:tableView];
  tableView.dataSource = dataSource;
  tableView.delegate = dataSource;

  CGRect frame = tableView.frame;
  frame.size = tableView.contentSize;
  tableView.frame = frame;
  tableView.bottom = _scrollView.contentSize.height;
  [tableView reloadData];
  
  CGFloat xOffset = (UISwipeGestureRecognizerDirectionLeft == direction) ? (CGRectGetWidth(tableView.frame)) : (-CGRectGetWidth(tableView.frame));
  tableView.transform = CGAffineTransformMakeTranslation(xOffset, 0.0f);
  
  [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
    
    tableView.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {
    
    [tableView removeFromSuperview];
    
  }];
   */
  
}

- (void)showRatingForBill:(OMNBill *)bill {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] initWithMediator:_restaurantMediator];
  ratingVC.backgroundImage = self.backgroundImage;
  ratingVC.delegate = self;
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

- (IBAction)payTap:(id)sender {
  
  if (_restaurantMediator.selectedOrder.paymentValueIsTooHigh) {
    
    __weak typeof(self)weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Сумма слишком большая", nil) message:nil cancelButtonTitle:NSLocalizedString(@"Отказаться", nil) otherButtonTitles:@[NSLocalizedString(@"Оплатить", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {

      if (buttonIndex != alertView.cancelButtonIndex) {
        [weakSelf processCardPayment];
      }
      
    }];
    
  }
  else {

    [self processCardPayment];
    
  }
  
}

- (void)processCardPayment {

  [OMNOrderAlertManager sharedManager].didCloseBlock = nil;
  [OMNOrderAlertManager sharedManager].didUpdateBlock = nil;
  
  OMNOrderPaymentVC *orderPaymentVC = [[OMNOrderPaymentVC alloc] initWithOrder:_restaurantMediator.selectedOrder restaurant:_restaurantMediator.restaurant];
  orderPaymentVC.delegate = self;
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:orderPaymentVC];
  navigationController.delegate = [OMNNavigationControllerDelegate sharedDelegate];
  [self.navigationController presentViewController:navigationController animated:YES completion:nil];
  
}

- (void)handlePan:(UIPanGestureRecognizer *)panGR {
  
  CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.95f, 0.95f);
  
  NSTimeInterval duration = 0.3;
  CGFloat shadowOpacity = 0.8f;
  
  switch (panGR.state) {
    case UIGestureRecognizerStateBegan: {

      CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
      anim.fromValue = @(0.0f);
      anim.toValue = @(shadowOpacity);
      anim.duration = duration;
      [self.tableView.layer addAnimation:anim forKey:@"shadowOpacity"];
      self.tableView.layer.shadowOpacity = shadowOpacity;
      
      [UIView animateWithDuration:0.3 animations:^{
        
        self.tableView.transform = scaleTransform;
        
      }];
      
    } break;
    case UIGestureRecognizerStateEnded:
    case UIGestureRecognizerStateCancelled: {
      
      CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
      anim.fromValue = @(self.tableView.layer.shadowOpacity);
      anim.toValue = @(0.0f);
      anim.duration = duration;
      [self.tableView.layer addAnimation:anim forKey:@"shadowOpacity"];
      self.tableView.layer.shadowOpacity = 0.0;
      
      [UIView animateWithDuration:duration animations:^{
        
        self.tableView.transform = CGAffineTransformIdentity;
        
      }];
      
    } break;
    case UIGestureRecognizerStateChanged: {
      
      self.tableView.transform = CGAffineTransformConcat(CGAffineTransformMakeTranslation([panGR translationInView:panGR.view].x, 0.0f), scaleTransform);
      
    } break;
    default:
      break;
  }
  
}

- (void)setOrderEnteredAmount:(long long)enteredAmount splitType:(SplitType)splitType {
  
  OMNOrder *order = _restaurantMediator.selectedOrder;
  order.enteredAmount = enteredAmount;
  order.splitType = splitType;
  
  switch (splitType) {
    case kSplitTypeOrders: {
      
      [order selectionDidFinish];
      
    } break;
    case kSplitTypeNone:
    case kSplitTypeNumberOfGuests:
    case kSplitTypePercent: {
      
      [order deselectAllItems];
      
    } break;
  }
  
  [self updateOrder];
  
}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self.delegate orderCalculationVCDidFinish:self];
  
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
  
  [self setOrderEnteredAmount:total splitType:splitType];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [_restaurantMediator.selectedOrder resetSelection];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  [self setupViewsWithKeyboardNotification:n keyboardShown:YES];
  
}

- (void)keyboardWillHide:(NSNotification *)n {

  [self setupViewsWithKeyboardNotification:n keyboardShown:NO];
  
}

- (void)setupViewsWithKeyboardNotification:(NSNotification *)n keyboardShown:(BOOL)keyboardShown {
  
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  _keyboardShown = keyboardShown;
  
  [self.navigationController setNavigationBarHidden:keyboardShown animated:YES];
  [_paymentView setKeyboardShown:keyboardShown];
  
  [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
    _paymentView.bottom = MIN(keyboardFrame.origin.y, self.view.height);
    _tableFadeView.alpha = (keyboardShown) ? (1.0f) : (0.0f);
    [self.view layoutIfNeeded];

  } completion:nil];
  
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  const CGFloat kDeltaOffset = 40.0f;
  if ((scrollView.contentOffset.y + scrollView.contentInset.top) < -kDeltaOffset) {
    
    [self calculatorTap];
    
  }
  
}

#pragma mark - OMNOrderPaymentVCDelegate

- (void)orderPaymentVCDidFinish:(OMNOrderPaymentVC *)orderPaymentVC withBill:(OMNBill *)bill {
  
  [self showRatingForBill:bill];
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)orderPaymentVCDidCancel:(OMNOrderPaymentVC *)orderPaymentVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)orderPaymentVCOrderDidClosed:(OMNOrderPaymentVC *)orderPaymentVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:^{
  
    [self.delegate orderCalculationVCDidCancel:self];
    
  }];
  
}

#pragma mark - OMNOrderTotalViewDelegate

- (void)orderTotalViewDidSplit:(OMNOrderActionView *)orderTotalView {
  
  [self calculatorTap];
  
}

- (void)orderTotalViewDidCancel:(OMNOrderActionView *)orderTotalView {
  
  [self setOrderEnteredAmount:_restaurantMediator.selectedOrder.expectedValue splitType:kSplitTypeNone];

}

#pragma mark - OMNPaymentFooterViewDelegate

- (void)paymentFooterView:(OMNPaymentFooterView *)paymentFooterView didSelectAmount:(long long)amount {

  [self setOrderEnteredAmount:amount splitType:kSplitTypePercent];
  
}

@end
