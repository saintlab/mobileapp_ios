//
//  GPaymentVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentVC.h"
#import "GPaymentVCDataSource.h"
#import "GPaymentFooterView.h"
#import "GRateAlertView.h"
#import "GControllerMediator.h"
#import "OMNCalculatorVC.h"
#import "GOrder.h"
#import "GUtils.h"
#import "GAmountPercentControl.h"
#import "UIView+frame.h"
#import <BlocksKit+UIKit.h>
#import "OMNPayCardVC.h"

@interface OMNPaymentVC ()
<GCalculatorVCDelegate,
GPaymentFooterViewDelegate>

@property (nonatomic, assign) double toPayAmount;

@end

@implementation OMNPaymentVC {
  
  GPaymentVCDataSource *_dataSource;

  __weak IBOutlet GPaymentFooterView *_paymentView;

  __weak IBOutlet UITableView *_tableView;
  __weak IBOutlet UIButton *_toPayButton;
  
  GOrder *_order;
  
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

  self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  self.navigationController.navigationBar.translucent = YES;
  self.navigationController.view.backgroundColor = [UIColor whiteColor];
  
  _dataSource = [[GPaymentVCDataSource alloc] initWithOrder:_order];
  _tableView.dataSource = _dataSource;

  _tableView.allowsSelection = NO;
  
  UIButton *rateButton = [[UIButton alloc] init];
  [rateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  [rateButton setTitle:NSLocalizedString(@"Заглушка", nil) forState:UIControlStateNormal];
  [rateButton bk_addEventHandler:^(id sender) {
    
    [[[GRateAlertView alloc] initWithBlock:^{
      
      
    }] show];
    
  } forControlEvents:UIControlEventTouchUpInside];
  
  NSArray *tips = @[[GTip tipWithPercent:10],
                    [GTip tipWithPercent:15],
                    [GTip tipWithPercent:20],
                    [GTip tipWithPercent:0],
                    ];
  
  _paymentView.calculationAmount = [[GCalculationAmount alloc] initWithExpectedValue:_order.total tips:tips];
  _paymentView.delegate = self;
  
  self.navigationItem.titleView = rateButton;

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(calculatorTap:)];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self handleKeyboardEvents];
  
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (IBAction)payTap:(id)sender {
  
  OMNPayCardVC *payCardVC = [[OMNPayCardVC alloc] init];
  payCardVC.delegate = self;
  [self.navigationController pushViewController:payCardVC animated:YES];
  
}

- (IBAction)calculatorTap:(id)sender {
  
  GOrder *order = [_order copy];
  [order deselectAll];
  
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithOrder:order];
  calculatorVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:calculatorVC] animated:YES completion:nil];

}

- (void)setToPayAmount:(double)toPayAmount {
  
  _toPayAmount = toPayAmount;
  
  [_toPayButton setTitle:[NSString stringWithFormat:@"%.0f", _toPayAmount] forState:UIControlStateNormal];
  _toPayButton.enabled = (_toPayAmount > 0);
  
}

- (void)handleKeyboardEvents {
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];

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
    
    _paymentView.bottom = keyboardFrame.origin.y;
    _tableView.bottom = _paymentView.top;
    
  } completion:nil];
  
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC didFinishWithTotal:(double)total {
  
  _paymentView.calculationAmount.enteredAmount = total;
  [_paymentView updateView];
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

#pragma mark - GPaymentFooterViewDelegate

- (void)paymentViewDidSelectAmount:(GPaymentFooterView *)paymentView {
  
//  [self setToPayAmount:paymentView.enteredAmount];
  
}

@end
