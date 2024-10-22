//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAnalitics.h"
#import "OMNCalculatorVC.h"
#import "OMNTransactionPaymentVC.h"
#import "OMNOrderDataSource.h"
#import "OMNOrderTableView.h"
#import "OMNOrderCalculationVC.h"
#import "OMNPaymentFooterView.h"
#import "UIView+frame.h"
#import <BlocksKit+UIKit.h>
#import "OMNOrderAlertManager.h"
#import "UIView+omn_autolayout.h"
#import "OMNSelectOrderButton.h"
#import "OMNRestaurant+omn_payment.h"
#import "OMNRatingVC.h"
#import <OMNStyler.h>
#import "OMNLoginVC.h"
#import "OMNAuthorization.h"
#import "OMNOrder+omn_helper.h"

@interface OMNOrderCalculationVC ()
<OMNCalculatorVCDelegate,
UITableViewDelegate,
OMNOrderTotalViewDelegate,
OMNPaymentFooterViewDelegate>

@property (nonatomic, strong, readonly) OMNRestaurantMediator *restaurantMediator;

@end

@implementation OMNOrderCalculationVC {
  
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  
  UIScrollView *_scrollView;
  UIView *_scrollContentView;
  
  BOOL _beginSplitAnimation;
  BOOL _keyboardShown;

  UIView *_tableFadeView;
  OMNTable *_table;
  
}

- (void)dealloc {
  
  [OMNOrderAlertManager sharedManager].order = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {

    _restaurantMediator = restaurantMediator;
    _table = restaurantMediator.table;
    
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
  
  OMNOrder *selectedOrder = _table.selectedOrder;
  [[OMNAnalitics analitics] logBillView:selectedOrder];

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kOMN_CLOSE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];

  [self updateOrder];
  [OMNOrderAlertManager sharedManager].order = selectedOrder;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableOrdersDidChange) name:OMNTableOrdersDidChangeNotification object:nil];
  
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

  @weakify(self)
  [OMNOrderAlertManager sharedManager].didCloseBlock = ^{
  
    @strongify(self)
    [self.delegate orderCalculationVCDidCancel:self];
    
  };
  
  [OMNOrderAlertManager sharedManager].didUpdateBlock = ^{
    
    @strongify(self)
    [self updateOrder];
    
  };
  [[OMNOrderAlertManager sharedManager] checkOrderIsClosed];
  
  [self updateOrder];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [OMNOrderAlertManager sharedManager].didCloseBlock = nil;
  [OMNOrderAlertManager sharedManager].didUpdateBlock = nil;
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews {

  [super viewDidLayoutSubviews];
  [self updateScrollViewInstets];
  [self.view layoutIfNeeded];
  
}

- (void)updateScrollViewInstets {
  
  _scrollView.contentSize = _scrollContentView.frame.size;
  CGFloat topInset = MIN(0.0f, _scrollView.height - _scrollContentView.height);
  CGFloat bottomInset = 1.0f;
  _scrollView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
  [_tableView scrollRectToVisible:CGRectMake(0.0f, _tableView.contentSize.height - 1.0f, 1.0f, 1.0f) animated:NO];
  
}

- (void)tableOrdersDidChange {
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
  
  OMNOrder *selectedOrder = _table.selectedOrder;
  if (selectedOrder) {
    
    _paymentView.order = selectedOrder;
    _dataSource.order = selectedOrder;
    _dataSource.fadeNonSelectedItems = (kSplitTypeOrders == selectedOrder.splitType);
    self.tableView.orderActionView.order = selectedOrder;
    [self.tableView reloadData];
    [self updateTitle];

  }
  
}

- (void)updateTitle {

  self.navigationItem.titleView = nil;
  if (_table.orders.count <= 1) {
    return;
  }

  NSUInteger index = _table.selectedOrderIndex;
  if (NSNotFound == index) {
    return;
  }

  UIButton *button = [[OMNSelectOrderButton alloc] init];
  NSString *title = [NSString stringWithFormat:kOMN_ORDER_NUMBER_HEADER_FORMAT, (long)index + 1];
  [button setTitle:title forState:UIControlStateNormal];
  [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
  
  [UIView performWithoutAnimation:^{
    
    [button sizeToFit];
    self.navigationItem.titleView = button;
    
  }];
  
}

- (OMNOrderTableView *)orderTableViewWithDataSource:(OMNOrderDataSource *)dataSource {
  
  OMNOrderTableView *tableView = [[OMNOrderTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds].CGPath;
  tableView.allowsSelection = NO;
  tableView.clipsToBounds = NO;
  tableView.scrollEnabled = NO;
  OMNOrderActionView *orderActionView = [[OMNOrderActionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), OMNStyler.orderTableFooterHeight)];
  orderActionView.delegate = self;
  orderActionView.order = dataSource.order;
  tableView.orderActionView = orderActionView;
  
  [OMNOrderDataSource registerCellsForTableView:tableView];
  
  tableView.delegate = dataSource;
  tableView.dataSource = dataSource;
  return tableView;
  
}

- (void)omn_setup {
    
  _scrollView = [UIScrollView omn_autolayoutView];
  _scrollView.clipsToBounds = NO;
  _scrollView.delegate = self;
  _scrollView.backgroundColor = [UIColor clearColor];
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  _scrollContentView = [[UIView alloc] initWithFrame:self.view.bounds];
  _scrollContentView.backgroundColor = [UIColor clearColor];
  [_scrollView addSubview:_scrollContentView];
  
  _tableFadeView = [UIView omn_autolayoutView];
  _tableFadeView.backgroundColor = [UIColor whiteColor];
  _tableFadeView.alpha = 0.0f;
  [_scrollView addSubview:_tableFadeView];
  
  _dataSource = [[OMNOrderDataSource alloc] init];
  _dataSource.order = _table.selectedOrder;
  _tableView = [self orderTableViewWithDataSource:_dataSource];
  [_scrollContentView addSubview:_tableView];

  NSDictionary *views =
  @{
    @"payment" : _paymentView,
    @"scrollView" : _scrollView,
    @"tableFadeView" : _tableFadeView,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]" options:kNilOptions metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_paymentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
  [_scrollView addGestureRecognizer:swipeGR];
  
  swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
  [_scrollView addGestureRecognizer:swipeGR];
  
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGR {
  
  NSInteger index = _table.selectedOrderIndex;
  if (NSNotFound == index) {
    return;
  }
  
  if (UISwipeGestureRecognizerDirectionRight == swipeGR.direction &&
      index > 0) {
    
    [self showOrderAtIndex:(index - 1) animationDirection:UISwipeGestureRecognizerDirectionRight];
    
  }
  else if (UISwipeGestureRecognizerDirectionLeft == swipeGR.direction &&
           index < _table.orders.count - 1) {
    
    [self showOrderAtIndex:(index + 1) animationDirection:UISwipeGestureRecognizerDirectionLeft];
    
  }
  
}

- (void)showOrderAtIndex:(NSInteger)index animationDirection:(UISwipeGestureRecognizerDirection)direction {

  UIView *oldScrollView = [_scrollView snapshotViewAfterScreenUpdates:NO];
  oldScrollView.frame = _scrollView.frame;
  [self.view addSubview:oldScrollView];
  
  CGFloat offset = CGRectGetWidth(_tableView.frame)*1.1f;
  CGFloat xOffset = (UISwipeGestureRecognizerDirectionLeft == direction) ? (offset) : (-offset);
  CGAffineTransform transform = CGAffineTransformMakeTranslation(xOffset, 0.0f);
  _tableView.transform = transform;
  
  UIView *oldPaymentView = [_paymentView snapshotViewAfterScreenUpdates:NO];
  oldPaymentView.frame = _paymentView.frame;
  [self.view addSubview:oldPaymentView];
  _paymentView.alpha = 0.0f;
  
  _table.selectedOrder = _table.orders[index];
  [self updateOrder];
  
  [UIView animateWithDuration:0.3 delay:0.1 options:kNilOptions animations:^{
    
    _paymentView.alpha = 1.0f;
    
  } completion:^(BOOL finished) {
    
  }];
  
  [UIView animateWithDuration:0.3 delay:0.0 options:kNilOptions animations:^{
    
    _paymentView.alpha = 1.0f;
    oldPaymentView.transform = CGAffineTransformInvert(transform);
    oldScrollView.transform = CGAffineTransformInvert(transform);
    _tableView.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {

    [self updateScrollViewInstets];
    [oldScrollView removeFromSuperview];
    [oldPaymentView removeFromSuperview];
    
  }];
  
}

- (IBAction)payTap:(id)sender {
  [self processCardPayment];
}

- (void)processCardPayment {

  [_table.selectedOrder checkPaymentValue].then(^{
    
    return [[OMNAuthorization authorization] checkAuthenticationToken];
    
  }).then(^(OMNUser *user) {
    
    OMNRestaurant *restaurant = _restaurantMediator.restaurant;
    OMNAcquiringTransaction *transaction = [[restaurant paymentFactory] transactionForUser:user order:_table.selectedOrder];
    OMNTransactionPaymentVC *transactionPaymentVC = [[OMNTransactionPaymentVC alloc] initWithVisitor:_restaurantMediator.visitor transaction:transaction];
    return [transactionPaymentVC pay:self.navigationController];
    
  }).then(^(OMNTransactionPaymentVC *paymentVC, OMNBill *bill) {
    
    [self transactionPaymentDidFinish:paymentVC.acquiringTransaction withBill:bill];
    
  }).catch(^(OMNError *error) {
    
    if (kOMNErrorInvalidUserToken == error.code) {
      
      [self requestAuthorization];
      
    }
    else if (kOMNErrorOrderClosed == error.code) {

      [self.restaurantMediator didFinishPayment];
      
    }
    
  });
  
}

- (void)requestAuthorization {
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  [loginVC requestLogin:self].then(^(OMNUser *user) {
    
    [self processCardPayment];
    
  }).finally(^{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
  });
  
}

- (void)transactionPaymentDidFinish:(OMNAcquiringTransaction *)acquiringTransaction withBill:(OMNBill *)bill {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] initWithTransaction:acquiringTransaction bill:bill];
  ratingVC.backgroundImage = _restaurantMediator.restaurant.decoration.woodBackgroundImage;
  OMNRestaurantMediator *restaurantMediator = _restaurantMediator;
  ratingVC.didFinishBlock = ^{
    [restaurantMediator didFinishPayment];
  };
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

- (void)setOrderEnteredAmount:(long long)enteredAmount splitType:(SplitType)splitType {
  
  OMNOrder *selectedOrder = _table.selectedOrder;
  selectedOrder.enteredAmount = enteredAmount;
  selectedOrder.splitType = splitType;
  
  switch (splitType) {
    case kSplitTypeOrders: {
      
      [selectedOrder selectionDidFinish];
      
    } break;
    case kSplitTypeNone:
    case kSplitTypeNumberOfGuests:
    case kSplitTypePercent: {
      
      [selectedOrder deselectAllItems];
      
    } break;
  }
  
  [self updateOrder];
  
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
  
  [self setOrderEnteredAmount:total splitType:splitType];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [_table.selectedOrder resetSelection];
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

#pragma mark - OMNOrderTotalViewDelegate

- (void)orderTotalViewDidSplit:(OMNOrderActionView *)orderTotalView {
  
  [self calculatorTap];
  
}

- (void)orderTotalViewDidCancel:(OMNOrderActionView *)orderTotalView {
  
  [self setOrderEnteredAmount:_table.selectedOrder.expectedValue splitType:kSplitTypeNone];

}

#pragma mark - OMNPaymentFooterViewDelegate

- (void)paymentFooterView:(OMNPaymentFooterView *)paymentFooterView didSelectAmount:(long long)amount {

  [self setOrderEnteredAmount:amount splitType:kSplitTypePercent];
  
}

@end
