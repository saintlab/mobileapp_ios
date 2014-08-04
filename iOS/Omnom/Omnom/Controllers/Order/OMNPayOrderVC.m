//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPayOrderVC.h"
#import "GPaymentVCDataSource.h"
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
#import "OMNBankCardsVC.h"
#import "OMNOrdersVC.h"
#import "OMNPaymentVC.h"
#import "OMNRatingVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNGPBPayVC.h"
#import "OMNSocketManager.h"
#import "OMNRestaurant.h"

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNGPBPayVCDelegate,
OMNBankCardsVCDelegate,
OMNPaymentVCDelegate,
OMNRatingVCDelegate,
UITableViewDelegate>

@end

@implementation OMNPayOrderVC {
  GPaymentVCDataSource *_dataSource;

  __weak IBOutlet OMNPaymentFooterView *_paymentView;
  __weak IBOutlet UIButton *_toPayButton;
  __weak IBOutlet UIImageView *_backgroundIV;
  BOOL _beginSplitAnimation;
  OMNOrder *_order;
  OMNRestaurant *_restaurant;
}

- (void)dealloc {
  [[OMNSocketManager manager] leave:_order.id];
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant order:(OMNOrder *)order {
  self = [super init];
  if (self) {
    _order = order;
    _restaurant = restaurant;
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  NSLog(@"viewDidLoad");
  [[OMNSocketManager manager] join:_order.id];
  
  _dataSource = [[GPaymentVCDataSource alloc] initWithOrder:_order];
  _tableView.dataSource = _dataSource;
  [_tableView reloadData];
  
  _tableView.allowsSelection = NO;
  [self setup];
  
  _paymentView.calculationAmount = [[OMNCalculationAmount alloc] initOrder:_order];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didFinish)];
  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
  
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white_pixel"] forBarMetrics:UIBarMetricsDefault];
  self.navigationController.navigationBar.shadowImage = nil;
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:NO animated:animated];
  
  _tableView.delegate = self;
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  self.edgesForExtendedLayout = UIRectEdgeAll;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  
  CGFloat realContentSize = _tableView.contentSize.height - _tableView.tableHeaderView.height;
  CGFloat bottomInset = MAX(0.0f, _tableView.height - realContentSize - _paymentView.height) + _paymentView.height;
  CGFloat visibleTablePart = _tableView.height - bottomInset;
  CGFloat topInset = MIN(0.0f, visibleTablePart - _tableView.contentSize.height);
  _tableView.contentInset = UIEdgeInsetsMake(topInset, 0.0f, bottomInset, 0.0f);
  _tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0f, 0.0f, bottomInset, 0.0f);

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  _beginSplitAnimation = NO;
  [self handleKeyboardEvents];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  _tableView.delegate = self;
  [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)didFinish {
  [self.delegate payOrderVCDidFinish:self];
}

- (void)setup {
  
  self.view.backgroundColor = [UIColor clearColor];
  _backgroundIV.backgroundColor = _restaurant.background_color;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorColor = [UIColor clearColor];
  _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _tableView.width, self.view.height)];
  _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
  
  _tableView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cheque_bottom_bg"]];
  _tableView.clipsToBounds = NO;
  NSDictionary *views =
  @{
    @"table" : _tableView,
    @"payment" : _paymentView,
    };
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSDictionary *metrics =
  @{
    @"paymentH" : @(_paymentView.height)
    };
  
  NSArray *constraintsTable_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[table]|" options:0 metrics:nil views:views];
  [self.view addConstraints:constraintsTable_H];
  
  NSArray *constraintsTable_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[table]|" options:0 metrics:metrics views:views];
  [self.view addConstraints:constraintsTable_V];
  
  UIButton *rateButton = [[UIButton alloc] init];
  [rateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [rateButton setTitle:NSLocalizedString(@"", nil) forState:UIControlStateNormal];
  [rateButton bk_addEventHandler:^(id sender) {
    
    [[[GRateAlertView alloc] initWithBlock:^{
      
      
    }] show];
    
  } forControlEvents:UIControlEventTouchUpInside];
//  self.navigationItem.titleView = rateButton;
  
  UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(calculatorTap:)];
  [_tableView addGestureRecognizer:tapGR];
  
}

- (IBAction)payTap:(id)sender {
  
  if (_paymentView.calculationAmount.paymentValueIsTooHigh) {
    
    __weak typeof(self)weakSelf = self;
    [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"Сумма слишком большая", nil) message:nil cancelButtonTitle:NSLocalizedString(@"Отказаться", nil) otherButtonTitles:@[NSLocalizedString(@"Оплатить", nil)] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {

      if (buttonIndex != alertView.cancelButtonIndex) {
        [weakSelf showCardPaymentVC];
      }
      
    }];
    
  }
  else {

    [self showCardPaymentVC];
    
  }
  
}

- (void)showCardPaymentVC {
  
  OMNBankCardsVC *bankCardsVC = [[OMNBankCardsVC alloc] init];
  bankCardsVC.delegate = self;
  [self.navigationController pushViewController:bankCardsVC animated:YES];
  
}

#pragma mark - OMNBankCardsVCDelegate

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didSelectCard:(OMNBankCard *)bankCard {
  
  _order.toPayAmount = _paymentView.calculationAmount.enteredAmount * 100;
  _order.tipAmount = _paymentView.calculationAmount.tipAmount * 100;
  
#if kUseGPBAcquiring
  
  OMNGPBPayVC *paymentVC = [[OMNGPBPayVC alloc] initWithCard:bankCard order:_order];
  paymentVC.navigationItem.title = NSLocalizedString(@"ГПБ", nil);
  paymentVC.delegate = self;
  [self.navigationController pushViewController:paymentVC animated:YES];
  
#else
  OMNPaymentVC *paymentVC = [[OMNPaymentVC alloc] initWithCard:bankCard order:_order];
  paymentVC.delegate = self;
  [self.navigationController pushViewController:paymentVC animated:YES];
#endif
  
}

- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNPaymentVCDelegate

- (void)paymentVCDidFinish:(OMNPaymentVC *)paymentVC {
  
  [self showRating];
  
}

- (void)showRating {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] init];
  ratingVC.delegate = self;
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self didFinish];
  
}

#pragma mark - OMNGPBPayVCDelegate

- (void)gpbVCDidPay:(OMNGPBPayVC *)gpbVC withOrder:(OMNOrder *)order {
  
  [[OMNAnalitics analitics] logPayment:nil];
  [self showRating];
  
}

- (void)gpbVCDidCancel:(OMNGPBPayVC *)gpbVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (IBAction)calculatorTap:(id)sender {
  
  _tableView.delegate = nil;
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithOrder:_order];
  calculatorVC.delegate = self;
  calculatorVC.navigationItem.title = NSLocalizedString(@"Калькуляция", nil);
  [self.navigationController pushViewController:calculatorVC animated:YES];

}


#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC didFinishWithTotal:(double)total {
  
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
  
  [self.navigationController setNavigationBarHidden:keyboardShown animated:YES];
  CGRect keyboardFrame = [n.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:500.0f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
    
    _paymentView.bottom = MIN(keyboardFrame.origin.y, self.view.height);
    _tableView.bottom = _paymentView.top;
    
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

  if (NO == _beginSplitAnimation &&
      (scrollView.contentOffset.y + scrollView.contentInset.top) < - 100.0f) {
    _beginSplitAnimation = YES;
    [self calculatorTap:nil];
  }
  
}

@end
