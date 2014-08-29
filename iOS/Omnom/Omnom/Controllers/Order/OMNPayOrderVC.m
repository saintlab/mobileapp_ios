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
#import "OMNGPBPayVC.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "OMNAnalitics.h"
#import "OMNOrdersVC.h"
#import "OMNRatingVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNGPBPayVC.h"
#import "OMNSocketManager.h"
#import "OMNVisitor.h"
#import "OMNMailRUPayVC.h"
#import "OMNAddBankCardVC.h"
#import "OMNPaymentNotificationControl.h"
#import "OMNNavigationController.h"
#import "OMNMailRuBankCardsModel.h"
#import <OMNStyler.h>

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNGPBPayVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate,
OMNAddBankCardVCDelegate,
OMNMailRUPayVCDelegate>

@end

@implementation OMNPayOrderVC {
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  __weak IBOutlet UIButton *_toPayButton;
  __weak IBOutlet UIImageView *_backgroundIV;
  __weak IBOutlet UILabel *_toPayLabel;
  __weak IBOutlet UILabel *_tipLabel;
  
  BOOL _beginSplitAnimation;
  OMNOrder *_order;
  OMNVisitor *_visitor;
  CGRect _keyboardFrame;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
  if (NO == _visitor.restaurant.is_demo) {
    [[OMNSocketManager manager] leave:_order.id];
  }
  
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

  if (NO == _visitor.restaurant.is_demo) {
    [[OMNSocketManager manager] join:_order.id];
  }
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_order];
  _dataSource.showTotalView = YES;
  
  _tableView.dataSource = _dataSource;
  [_tableView reloadData];
  
  _tableView.allowsSelection = NO;
  [self setup];

  if (_visitor.orders.count > 1) {
    
    NSUInteger index = [_visitor.orders indexOfObject:_visitor.selectedOrder];
    if (index != NSNotFound) {
      UIButton *button = [[UIButton alloc] init];
      button.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Medium" size:20.0f];
      [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
      [button setTitle:[NSString stringWithFormat:@"Счет N%d", index + 1] forState:UIControlStateNormal];
      button.layer.borderColor = [UIColor blackColor].CGColor;
      button.contentEdgeInsets = UIEdgeInsetsMake(3.0f, 10.0f, 3.0f, 10.0f);
      button.layer.borderWidth = 1.0f;
      button.layer.cornerRadius = 2.0f;
      [button addTarget:self action:@selector(selectedOrderTap) forControlEvents:UIControlEventTouchUpInside];
      [button sizeToFit];
      self.navigationItem.titleView = button;
    }

  }
  
  _paymentView.calculationAmount = [[OMNCalculationAmount alloc] initWithOrder:_order];

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didPay:) name:OMNSocketIODidPayNotification object:nil];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"calc_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(calculatorTap:)];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;

  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
  _tableView.delegate = self;
  [self.view insertSubview:_tableView belowSubview:_paymentView];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeAll;
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleDefault;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  [self layoutTableView];
}

- (void)layoutTableView {
  CGFloat bottomInset = _paymentView.height + CGRectGetHeight(_keyboardFrame);
  CGFloat visibleTablePart = _tableView.height - bottomInset;
  CGFloat topInset = MIN(0.0f, visibleTablePart - _tableView.contentSize.height);
  _tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  _beginSplitAnimation = NO;
  _tableView.scrollEnabled = YES;
  [self handleKeyboardEvents];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  _tableView.delegate = self;
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
  _tableView.delegate = nil;
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithOrder:_order];
  calculatorVC.delegate = self;
  calculatorVC.navigationItem.title = NSLocalizedString(@"Калькуляция", nil);
  [self.navigationController pushViewController:calculatorVC animated:YES];
  
}

- (void)cancelTap {
  [self.delegate payOrderVCDidCancel:self];
}

- (void)didPay:(NSNotification *)n {
  
  [OMNPaymentNotificationControl showWithInfo:n.userInfo];

}

- (void)setup {
  
  _tipLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _tipLabel.textColor = [colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.6f];
  _toPayLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _toPayLabel.textColor = [colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.6f];
  
  self.view.backgroundColor = [UIColor clearColor];
  _backgroundIV.backgroundColor = _visitor.restaurant.background_color;

  NSDictionary *views =
  @{
    @"table" : _tableView,
    @"payment" : _paymentView,
    };
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:nil views:views]];
  
  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calculatorTap:)];
  [_tableView addGestureRecognizer:tapGR];
  
}

- (void)showRating {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] init];
  ratingVC.order = _order;
  ratingVC.delegate = self;
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

- (IBAction)payTap:(id)sender {
  
  if (_paymentView.calculationAmount.paymentValueIsTooHigh) {
    
    __weak typeof(self)weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Сумма слишком большая", nil) message:nil cancelButtonTitle:NSLocalizedString(@"Отказаться", nil) otherButtonTitles:@[NSLocalizedString(@"Оплатить", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {

      if (buttonIndex != alertView.cancelButtonIndex) {
        [weakSelf processCardPaymentVC];
      }
      
    }];
    
  }
  else {

    [self processCardPaymentVC];
    
  }
  
}

- (void)processCardPaymentVC {

  _order.toPayAmount = _paymentView.calculationAmount.totalValue;
  _order.tipAmount = _paymentView.calculationAmount.tipAmount;

#if kUseGPBAcquiring
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.delegate = self;
  [self.navigationController pushViewController:addBankCardVC animated:YES];

#else
  
  OMNMailRUPayVC *mailRUPayVC = [[OMNMailRUPayVC alloc] initWithOrder:_order];
  mailRUPayVC.demo = _visitor.restaurant.is_demo;
  mailRUPayVC.delegate = self;
  UINavigationController *navigationController = [[OMNNavigationController alloc] initWithRootViewController:mailRUPayVC];
  [self.navigationController presentViewController:navigationController animated:YES completion:^{
    
  }];

#endif
  
  
}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self.delegate payOrderVCDidFinish:self];
  
}

#pragma mark - OMNGPBPayVCDelegate

- (void)gpbVCDidPay:(OMNGPBPayVC *)gpbVC withOrder:(OMNOrder *)order {
  
  [[OMNAnalitics analitics] logPayment:nil];
  [self showRating];
  
}

- (void)gpbVCDidCancel:(OMNGPBPayVC *)gpbVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC didFinishWithTotal:(long long)total {
  
  _paymentView.calculationAmount.enteredAmount = total;
  [_paymentView updateView];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)handleKeyboardEvents {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [self.view bringSubviewToFront:scrollView];
  [self.view bringSubviewToFront:_toPayButton];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self.view insertSubview:scrollView belowSubview:_paymentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if ((scrollView.contentOffset.y + scrollView.contentInset.top) < - 70.0f) {
    CGPoint offset = scrollView.contentOffset;
    scrollView.scrollEnabled = NO;
    //remove glitch when content scrolls to top
    scrollView.contentOffset = offset;
    [self calculatorTap:nil];
  }
  
}

#pragma mark - OMNAddBankCardVCDelegate

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCardInfo *)bankCardInfo {
  
  OMNGPBPayVC *gpbVC = [[OMNGPBPayVC alloc] initWithCard:bankCardInfo order:_order];
  gpbVC.navigationItem.title = NSLocalizedString(@"ГПБ", nil);
  gpbVC.delegate = self;
  [self.navigationController pushViewController:gpbVC animated:YES];
  
}

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNMailRUPayVCDelegate

- (void)mailRUPayVCDidFinish:(OMNMailRUPayVC *)mailRUPayVC {
  
  [self showRating];
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)mailRUPayVCDidCancel:(OMNMailRUPayVC *)mailRUPayVC {
  
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
  
}

@end
