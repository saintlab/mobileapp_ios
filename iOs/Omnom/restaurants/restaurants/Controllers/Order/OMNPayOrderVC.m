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
#import "OMNPayCardVC.h"
#import "OMNGPBPayVC.h"
#import "UINavigationController+omn_replace.h"
#import "OMNOrder+omn_calculationAmount.h"
#import <BlocksKit/UIAlertView+BlocksKit.h>
#import "OMNAnalitics.h"
#import "OMNBankCardsVC.h"
#import "OMNOrdersVC.h"
#import "OMNPaymentVC.h"
#import "OMNRatingVC.h"

@interface OMNPayOrderVC ()
<OMNCalculatorVCDelegate,
OMNPayCardVCDelegate,
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
  
  OMNOrder *_order;
  
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
  
  _dataSource = [[GPaymentVCDataSource alloc] initWithOrder:_order];
  _tableView.dataSource = _dataSource;
  [_tableView reloadData];
  
  _tableView.allowsSelection = NO;
  [self setup];
  
  _paymentView.calculationAmount = [_order omn_calculationAmount];
  
  _tableView.backgroundView = [[UIView alloc] init];
  UIButton *b = [UIButton buttonWithType:UIButtonTypeContactAdd];
  b.center = CGPointMake(100, _tableView.backgroundView.height - 20);
  [_tableView.backgroundView addSubview:b];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self handleKeyboardEvents];

}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  _tableView.delegate = self;
  [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)setup {
  
  if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
  }
  
  _backgroundIV.image = [UIImage imageNamed:@"background_blur"];
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.separatorColor = [UIColor clearColor];
  _tableView.tableFooterView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cheque_bottom_bg"]];
  _tableView.clipsToBounds = NO;
  
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

- (void)viewWillAppear:(BOOL)animated {
  
  [super viewWillAppear:animated];
  _tableView.delegate = self;
  
  if (!_tableView.tableHeaderView) {
    CGFloat tableFooterHeight = MAX(0, self.view.height - _tableView.contentSize.height);
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, tableFooterHeight)];
    _tableView.tableHeaderView.backgroundColor = [UIColor whiteColor];
    
    _tableView.height = _tableView.contentSize.height;
    _tableView.bottom = _paymentView.top;
  }
  
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
  
  OMNPaymentVC *paymentVC = [[OMNPaymentVC alloc] initWithCard:bankCard order:_order];
  paymentVC.delegate = self;
  [self.navigationController pushViewController:paymentVC animated:YES];
  
}

- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNPaymentVCDelegate

- (void)paymentVCDidFinish:(OMNPaymentVC *)paymentVC {
  
  OMNRatingVC *ratingVC = [[OMNRatingVC alloc] init];
  ratingVC.delegate = self;
  [self.navigationController pushViewController:ratingVC animated:YES];
  
}

#pragma mark - OMNRatingVCDelegate

- (void)ratingVCDidFinish:(OMNRatingVC *)ratingVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNPayCardVCDelegate

- (void)payCardVC:(OMNPayCardVC *)payVC requestPayWithCardInfo:(OMNBankCard *)cardInfo {
  
  _order.toPayAmount = _paymentView.calculationAmount.enteredAmount * 100;
  _order.tipAmount = _paymentView.calculationAmount.tipAmount * 100;
  
  OMNGPBPayVC *gpbPayVC = [[OMNGPBPayVC alloc] initWithCard:cardInfo order:_order];
  gpbPayVC.delegate = self;
  gpbPayVC.navigationItem.title = NSLocalizedString(@"ГПБ", nil);
  [self.navigationController omn_replaceCurrentViewControllerWithController:gpbPayVC animated:YES];
  
}

#pragma mark - OMNGPBPayVCDelegate

- (void)gpbVCDidPay:(OMNGPBPayVC *)gpbVC withOrder:(OMNOrder *)order {
  
  [[OMNAnalitics analitics] logPayment:nil];
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)gpbVCDidCancel:(OMNGPBPayVC *)gpbVC {
  
}

- (void)payCardVCDidPayCash:(OMNPayCardVC *)payVC {
  
  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Официант скоро подойдет", nil) message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
  
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
  
//  [self dismissViewControllerAnimated:YES completion:nil];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
//  [self dismissViewControllerAnimated:YES completion:nil];
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  return;
  if (scrollView.contentOffset.y < - 20.0f) {
    scrollView.userInteractionEnabled = NO;
    [self calculatorTap:nil];
    scrollView.userInteractionEnabled = YES;
  }
  
}

@end
