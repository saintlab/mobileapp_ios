//
//  OMNPayOrderVC.m
//  restaurants
//
//  Created by tea on 21.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPayOrderVC.h"
#import "OMNOrder.h"

@interface OMNPayOrderVC ()

@end

@implementation OMNPayOrderVC
{
  OMNOrder *_order;
  __weak IBOutlet UITextField *_amountTF;
}

- (instancetype)initWithOrder:(OMNOrder *)order
{
  self = [super initWithNibName:@"OMNPayOrderVC" bundle:nil];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _amountTF.placeholder = [NSString stringWithFormat:@"Введите сумму платежа (%.2f)", [_order total] / 100.];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Pay" style:UIBarButtonItemStylePlain target:self action:@selector(payTap)];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [_amountTF becomeFirstResponder];
}

- (void)payTap
{

  
  NSInteger amount = floor([_amountTF.text doubleValue]) * 100;
  
  if (amount <= 0)
  {
    [[[UIAlertView alloc] initWithTitle:@"Введите сумму платежа" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    return;
  }
  
#warning  createAcquiringOrderAmount
//    __weak typeof(self)weakSelf = self;
//  [_order createAcquiringOrderAmount:amount orderID:1 completition:^(OMNOrder *order) {
//
//    [weakSelf payForOrder:order];
//    
//  } failure:^(NSError *error) {
//
//    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
//    
//  }];
  
}

- (void)payForOrder:(OMNOrder *)order
{
//  _OMNCardPayVC *cardPayVC = [[_OMNCardPayVC alloc] initWithOrder:order];
//  cardPayVC.title = @"Газпромбанк";
//  cardPayVC.delegate = _delegate;
//  [self.navigationController pushViewController:cardPayVC animated:YES];
}

@end
