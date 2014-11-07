//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPayOrderVC.h"
#import "OMNOrderDataSource.h"
#import "OMNPaymentFooterView.h"
#import <BlocksKit+UIKit.h>
#import "GRateAlertView.h"
#import "OMNCalculatorVC.h"
#import "OMNOrder.h"
#import "OMNAmountPercentControl.h"
#import "UIView+frame.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "OMNAnalitics.h"
#import "OMNOrdersVC.h"
#import "OMNRatingVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNVisitor.h"
#import "OMNMailRUPayVC.h"
#import "OMNNavigationController.h"
#import "OMNMailRuBankCardsModel.h"
#import <OMNStyler.h>
#import "OMNOrderTableView.h"
#import "UIImage+omn_helper.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNOrderTotalView.h"
#import "OMNSelectOrderButton.h"

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate,
OMNMailRUPayVCDelegate,
OMNOrderTotalViewDelegate>

@end

@implementation OMNPayOrderVC {
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  
  UIScrollView *_scrollView;
  
  BOOL _beginSplitAnimation;
  BOOL _keyboardShown;
  OMNOrder *_order;
  OMNVisitor *_visitor;
  OMNOrderTotalView *_orderTotalView;
  UIView *_tableFadeView;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    _order = visitor.selectedOrder;
    _visitor = visitor;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor clearColor];
  self.backgroundImage = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:_visitor.restaurant.decoration.background_color];
  
  [self omn_setup];

  if (_visitor.orders.count > 1) {
    
    NSUInteger index = [_visitor.orders indexOfObject:_visitor.selectedOrder];
    if (index != NSNotFound) {
      UIButton *button = [[OMNSelectOrderButton alloc] init];
      NSString *title = [NSString stringWithFormat:NSLocalizedString(@"ORDER_NUMBER_TITLE %ld", @"Счёт {number}"), (long)index + 1];
      [button setTitle:title forState:UIControlStateNormal];
      [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
      [button sizeToFit];
      self.navigationItem.titleView = button;
    }

  }
  
  _paymentView.order = _order;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:_visitor];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"calc_icon"] color:[UIColor blackColor] target:self action:@selector(calculatorTap)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  _orderTotalView.order = _order;
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_gray_bg"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  
}

- (void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  _beginSplitAnimation = NO;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)selectedOrderTap {
  [self.delegate payOrderVCRequestOrders:self];
}

- (void)calculatorTap {
  
  if (_beginSplitAnimation ||
      _keyboardShown) {
    return;
  }
  _beginSplitAnimation = YES;
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithOrder:_order];
  calculatorVC.delegate = self;
  [self.navigationController pushViewController:calculatorVC animated:YES];
  
}

- (void)cancelTap {
  [self.delegate payOrderVCDidCancel:self];
}

- (void)orderDidChange:(NSNotification *)n {

  _paymentView.order = _order;
  [self.tableView reloadData];
  [self layoutTableView];
  
}

- (void)omn_setup {
    
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  _scrollView.clipsToBounds = NO;
  _scrollView.delegate = self;
  _scrollView.showsVerticalScrollIndicator = NO;
  [self.view addSubview:_scrollView];
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_order];
  _tableView = [[OMNOrderTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.allowsSelection = NO;
  [_scrollView addSubview:_tableView];

  _orderTotalView = [[OMNOrderTotalView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];
  _orderTotalView.delegate = self;

  UIImageView *endBillIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_zubchiki"]];
  endBillIV.top = CGRectGetHeight(_orderTotalView.frame);
  
  UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), CGRectGetHeight(endBillIV.frame) + CGRectGetHeight(_orderTotalView.frame))];
  [footerView addSubview:endBillIV];
  [footerView addSubview:_orderTotalView];
  
  _tableView.tableFooterView = footerView;
  _tableView.dataSource = _dataSource;
  _tableView.delegate = _dataSource;
  [_dataSource registerCellsForTableView:_tableView];
  [_tableView reloadData];
  
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
  
  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calculatorTap)];
  [_tableView addGestureRecognizer:tapGR];
  
  [self.view layoutIfNeeded];
  
}

- (void)showRatingForBill:(OMNBill *)bill {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] init];
  ratingVC.backgroundImage = self.backgroundImage;
  ratingVC.order = _order;
  ratingVC.visitor = _visitor;
  ratingVC.delegate = self;
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

- (IBAction)payTap:(id)sender {
  
  if (_paymentView.order.paymentValueIsTooHigh) {
    
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

  OMNMailRUPayVC *mailRUPayVC = [[OMNMailRUPayVC alloc] initWithOrder:_order];
  mailRUPayVC.demo = _visitor.restaurant.is_demo;
  mailRUPayVC.delegate = self;
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:mailRUPayVC];
  navigationController.delegate = self.navigationController.delegate;
  [self.navigationController presentViewController:navigationController animated:YES completion:^{
    
  }];

}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self.delegate payOrderVCDidFinish:self];
  
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC splitType:(SplitType)splitType didFinishWithTotal:(long long)total {
  
  _order.enteredAmount = total;
  _order.splitType = splitType;
  _paymentView.order = _order;
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)keyboardWillShow:(NSNotification *)n {
  
  [self setupViewsWithNotification:n keyboardShown:YES];
  
}

- (void)keyboardWillHide:(NSNotification *)n {

  [self setupViewsWithNotification:n keyboardShown:NO];
  
}

- (void)setupViewsWithNotification:(NSNotification *)n keyboardShown:(BOOL)keyboardShown {
  
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

#pragma mark - OMNMailRUPayVCDelegate

- (void)mailRUPayVCDidFinish:(OMNMailRUPayVC *)mailRUPayVC withBill:(OMNBill *)bill {
  
  [self showRatingForBill:bill];
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)mailRUPayVCDidCancel:(OMNMailRUPayVC *)mailRUPayVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)mailRUPayVCOrderDidClosed:(OMNMailRUPayVC *)mailRUPayVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:^{
  
    [self.delegate payOrderVCDidCancel:self];
    
  }];
  
}

#pragma mark - OMNOrderTotalViewDelegate

- (void)orderTotalViewDidSplit:(OMNOrderTotalView *)orderTotalView {
  
  [self calculatorTap];
  
}

- (void)orderTotalViewDidCancel:(OMNOrderTotalView *)orderTotalView {
  
  [_order deselectAllItems];
  [UIView transitionWithView:_orderTotalView duration:0.3 options:kNilOptions animations:^{
    _orderTotalView.order = _order;
  } completion:nil];
  
}

@end
