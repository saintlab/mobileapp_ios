//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GRateAlertView.h"
#import "OMNAmountPercentControl.h"
#import "OMNAnalitics.h"
#import "OMNCalculatorVC.h"
#import "OMNMailRUPayVC.h"
#import "OMNMailRuBankCardsModel.h"
#import "OMNNavigationController.h"
#import "OMNOrder.h"
#import "OMNOrderDataSource.h"
#import "OMNOrderTableView.h"
#import "OMNOrderActionView.h"
#import "OMNOrdersVC.h"
#import "OMNPayOrderVC.h"
#import "OMNPaymentFooterView.h"
#import "OMNRatingVC.h"
#import "OMNSelectOrderButton.h"
#import "OMNVisitor.h"
#import "OMNVisitor+network.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIImage+omn_helper.h"
#import "UIView+frame.h"
#import <BlocksKit+UIKit.h>
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import <OMNStyler.h>

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate,
OMNMailRUPayVCDelegate,
OMNOrderTotalViewDelegate,
OMNPaymentFooterViewDelegate>

@end

@implementation OMNPayOrderVC {
  OMNOrderDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  
  UIScrollView *_scrollView;
  
  BOOL _beginSplitAnimation;
  BOOL _keyboardShown;
  OMNOrder *_order;
  OMNVisitor *_visitor;
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
  
  [self omn_setup];
  
  OMNRestaurantDecoration *decoration = _visitor.restaurant.decoration;
  self.backgroundImage = [[UIImage imageNamed:@"wood_bg"] omn_blendWithColor:decoration.background_color];
  [_paymentView configureWithColor:decoration.background_color antogonistColor:decoration.antagonist_color];
  
  [[OMNAnalitics analitics] logBillView:_order];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:_visitor];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(visitorOrdersDidChange:) name:OMNVisitorOrdersDidChangeNotification object:_visitor];
  
  _paymentView.delegate = self;
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Закрыть", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];

  [self updateWithOrder:_visitor.selectedOrder];
  
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

  [self updateWithOrder:_order];
  
}

- (void)visitorOrdersDidChange:(NSNotification *)n {
  
  [self updateWithOrder:_visitor.selectedOrder];
  
}

- (void)updateWithOrder:(OMNOrder *)order {
  
  _order = order;
  _paymentView.order = order;
  _dataSource.order = order;
  self.tableView.orderActionView.order = order;
  [self.tableView reloadData];
  [self layoutTableView];
  [self updateTitle];
  
}

- (void)updateTitle {
  
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
  else {
    
    self.navigationItem.titleView = nil;
    
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
  
  UIPanGestureRecognizer *tapGR = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
  [self.view addGestureRecognizer:tapGR];
  
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
  
  if (_order.paymentValueIsTooHigh) {
    
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
  
  _order.enteredAmount = enteredAmount;
  _order.splitType = splitType;
  
  switch (splitType) {
    case kSplitTypeOrders: {
      
      [_order selectionDidChange];
      
    } break;
    case kSplitTypeNone:
    case kSplitTypeNumberOfGuests:
    case kSplitTypePercent: {
      
      [_order deselectAllItems];
      
    } break;
  }
  
  BOOL fadeNonSelectedItems = (kSplitTypeOrders == splitType);
  [self setNonSelectedOrderItemsFaded:fadeNonSelectedItems];
  
  _paymentView.order = _order;
  
}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self.delegate payOrderVCDidFinish:self];
  
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

- (void)orderTotalViewDidSplit:(OMNOrderActionView *)orderTotalView {
  
  [self calculatorTap];
  
}

- (void)orderTotalViewDidCancel:(OMNOrderActionView *)orderTotalView {
  
  [self setOrderEnteredAmount:_order.expectedValue splitType:kSplitTypeNone];

}

#pragma mark - OMNPaymentFooterViewDelegate

- (void)paymentFooterView:(OMNPaymentFooterView *)paymentFooterView didSelectAmount:(long long)amount {

  [self setOrderEnteredAmount:amount splitType:kSplitTypePercent];
  
}

@end
