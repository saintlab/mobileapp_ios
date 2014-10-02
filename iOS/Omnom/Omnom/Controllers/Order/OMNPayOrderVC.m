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

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate,
OMNMailRUPayVCDelegate>

@end

@implementation OMNPayOrderVC {
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  
  UIScrollView *_scrollView;
  
  BOOL _beginSplitAnimation;
  OMNOrder *_order;
  OMNVisitor *_visitor;
  CGRect _keyboardFrame;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    _keyboardFrame = CGRectZero;
    _order = visitor.selectedOrder;
    _visitor = visitor;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor clearColor];
  self.backgroundImage = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:_visitor.restaurant.decoration.background_color];
  
  [self setup];

  if (_visitor.orders.count > 1) {
    
    NSUInteger index = [_visitor.orders indexOfObject:_visitor.selectedOrder];
    if (index != NSNotFound) {
      UIButton *button = [[UIButton alloc] init];
      button.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
      [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [button setTitle:[NSString stringWithFormat:@"Счёт %lu", (long unsigned)index + 1] forState:UIControlStateNormal];
      button.layer.borderColor = [UIColor blackColor].CGColor;
      button.contentEdgeInsets = UIEdgeInsetsMake(3.0f, 10.0f, 3.0f, 10.0f);
      button.layer.borderWidth = 1.0f;
      button.layer.cornerRadius = 2.0f;
      [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
      [button sizeToFit];
      self.navigationItem.titleView = button;
    }

  }
  
  _paymentView.order = _order;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:_visitor];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calc_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(calculatorTap:)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_gray_bg"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeAll;
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self layoutTableView];
  [self.view layoutIfNeeded];
}

- (void)layoutTableView {
  
  [_tableView reloadData];
  CGRect frame = _tableView.frame;
  frame.size = _tableView.contentSize;
  _tableView.frame = frame;
  _scrollView.contentSize = _tableView.frame.size;
  CGFloat topInset = MIN(0.0f, _scrollView.height - _tableView.height);
  CGFloat bottomInset = 1.0f;
  _scrollView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
  
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

- (void)selectedOrderTap {
  [self.delegate payOrderVCRequestOrders:self];
}

- (IBAction)calculatorTap:(id)sender {
  
  if (_beginSplitAnimation) {
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
  [self layoutTableView];
  
}

- (void)setup {
    
  _scrollView = [[UIScrollView alloc] init];
  _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
  _scrollView.clipsToBounds = NO;
  _scrollView.delegate = self;
  [self.view addSubview:_scrollView];
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_order];
  _dataSource.showTotalView = YES;
  
  _tableView = [[OMNOrderTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.allowsSelection = NO;
  [_scrollView addSubview:_tableView];
  
  _tableView.dataSource = _dataSource;
  _tableView.delegate = _dataSource;
  [_dataSource registerCellsForTableView:self.tableView];
  [_tableView reloadData];

  
  NSDictionary *views =
  @{
    @"table" : _tableView,
    @"payment" : _paymentView,
    @"scrollView" : _scrollView,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]" options:0 metrics:nil views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_paymentView attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
  
  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calculatorTap:)];
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
  _keyboardFrame = (keyboardShown) ? (keyboardFrame) : (CGRectZero);
  
  [self.navigationController setNavigationBarHidden:keyboardShown animated:YES];
  [_paymentView setKeyboardShown:keyboardShown];
  [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
    _paymentView.bottom = MIN(keyboardFrame.origin.y, self.view.height);
    [self layoutTableView];

  } completion:nil];
  
}

#pragma mark - UITableViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  const CGFloat kDeltaOffset = 40.0f;
  if ((scrollView.contentOffset.y + scrollView.contentInset.top) < -kDeltaOffset) {
    [self calculatorTap:nil];
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

@end
