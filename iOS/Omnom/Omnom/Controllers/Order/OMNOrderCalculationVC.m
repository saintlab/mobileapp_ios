//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GRateAlertView.h"
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
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <OMNStyler.h>

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
  
  BOOL _beginSplitAnimation;
  BOOL _keyboardShown;

  UIView *_tableFadeView;
  __weak OMNOrderPaymentVC *_orderPaymentVC;
  
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (void)dealloc {
  
  @try {
    [_restaurantMediator removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedOrder))];
  }
  @catch (NSException *exception) {}
  
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

  self.view.backgroundColor = [UIColor clearColor];
  
  [self omn_setup];
  
  OMNRestaurantDecoration *decoration = _restaurantMediator.restaurant.decoration;
  self.backgroundImage = decoration.woodBackgroundImage;

  [_paymentView configureWithColor:decoration.background_color antogonistColor:decoration.antagonist_color];
  _paymentView.delegate = self;
  
  [[OMNAnalitics analitics] logBillView:_restaurantMediator.selectedOrder];

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];

  [_restaurantMediator addObserver:self forKeyPath:NSStringFromSelector(@selector(selectedOrder)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];
  
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
  [self layoutTableView];
  [self.view layoutIfNeeded];
  
  CGRect tableFrame = _tableView.frame;
  tableFrame.size.height -= 6.0f;
  _tableFadeView.frame = tableFrame;
  
}

- (void)layoutTableView {
  
  CGRect frame = _tableView.frame;
  frame.size = _tableView.contentSize;
  _tableView.frame = frame;
  _scrollView.contentSize = _tableView.frame.size;
  CGFloat topInset = MIN(0.0f, _scrollView.height - _tableView.height);
  CGFloat bottomInset = 1.0f;
  _scrollView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([object isEqual:_restaurantMediator] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(selectedOrder))]) {
    
    [self updateOrder];
    
  } else {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
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

- (void)showCloseOrderAlertIfNeeded {
  
  if (_orderPaymentVC) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"ORDER_DID_CLOSE_ALERT_TITLE", @"Этот счёт закрыт заведением для просмотра и оплаты") message:nil cancelButtonTitle:NSLocalizedString(@"ORDER_CLOSE_ALERT_BUTTON_TITLE", @"Выйти") otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    
    [weakSelf.delegate orderCalculationVCDidCancel:weakSelf];
    
  }];
  
}

- (void)updateOrder {
  
  OMNOrder *order = _restaurantMediator.selectedOrder;
  if (order) {
    
    _paymentView.order = order;
    _dataSource.order = order;
    self.tableView.orderActionView.order = order;
    [self.tableView reloadData];
    [self layoutTableView];
    [self updateTitle];

  }
  else {
    
    [self showCloseOrderAlertIfNeeded];
    
  }
  
}

- (void)updateTitle {

  self.navigationItem.titleView = nil;
  if (_restaurantMediator.orders.count > 1) {
    
    NSUInteger index = [_restaurantMediator.orders indexOfObject:_restaurantMediator.selectedOrder];
    if (NSNotFound != index) {
      
      UIButton *button = [[OMNSelectOrderButton alloc] init];
      NSString *title = [NSString stringWithFormat:NSLocalizedString(@"ORDER_NUMBER_TITLE %ld", @"Счёт {number}"), (long)index + 1];
      [button setTitle:title forState:UIControlStateNormal];
      [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
      [button sizeToFit];
      self.navigationItem.titleView = button;
      
    }
    
  }
  
}

- (OMNOrderTableView *)orderTableView {
  
  OMNOrderTableView *tableView = [[OMNOrderTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  tableView.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tableView.bounds].CGPath;
  tableView.layer.shadowColor = [UIColor blackColor].CGColor;
  tableView.layer.shadowRadius = 30.0f;
  tableView.layer.masksToBounds = NO;
  tableView.allowsSelection = NO;
  
  OMNOrderActionView *orderActionView = [[OMNOrderActionView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), kOrderTableFooterHeight)];
  orderActionView.delegate = self;
  tableView.orderActionView = orderActionView;
  
  return tableView;
  
}

- (void)omn_setup {
    
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  _scrollView.clipsToBounds = NO;
  _scrollView.delegate = self;
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:nil];
  
  _tableView = [self orderTableView];
  [_scrollView addSubview:_tableView];

  _tableView.dataSource = _dataSource;
  _tableView.delegate = _dataSource;
  [_dataSource registerCellsForTableView:_tableView];
  
  _tableFadeView = [[UIView alloc] init];
  _tableFadeView.userInteractionEnabled = YES;
  _tableFadeView.backgroundColor = [UIColor whiteColor];
  _tableFadeView.alpha = 0.0f;
  [_scrollView addSubview:_tableFadeView];
  
  NSDictionary *views =
  @{
    @"table" : _tableView,
    @"payment" : _paymentView,
    @"scrollView" : _scrollView,
    @"tableFadeView" : _tableFadeView,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_paymentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
//  UIPanGestureRecognizer *tapGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
//  [self.view addGestureRecognizer:tapGR];
  
  [self.view layoutIfNeeded];
  
}

- (void)showRatingForBill:(OMNBill *)bill {
  
#warning showRatingForBill
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

  OMNOrderPaymentVC *orderPaymentVC = [[OMNOrderPaymentVC alloc] initWithOrder:_restaurantMediator.selectedOrder restaurant:_restaurantMediator.restaurant];
  orderPaymentVC.delegate = self;
  _orderPaymentVC = orderPaymentVC;
  
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:orderPaymentVC];
  navigationController.delegate = self.navigationController.delegate;
  [self.navigationController presentViewController:navigationController animated:YES completion:nil];

}

- (void)setNonSelectedOrderItemsFaded:(BOOL)faded {
  
  _dataSource.fadeNonSelectedItems = faded;
  [_tableView reloadData];
  
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
      
      [order selectionDidChange];
      
    } break;
    case kSplitTypeNone:
    case kSplitTypeNumberOfGuests:
    case kSplitTypePercent: {
      
      [order deselectAllItems];
      
    } break;
  }
  
  BOOL fadeNonSelectedItems = (kSplitTypeOrders == splitType);
  [self setNonSelectedOrderItemsFaded:fadeNonSelectedItems];
  
  _paymentView.order = order;
  
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
