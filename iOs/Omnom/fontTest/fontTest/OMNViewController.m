//
//  OMNViewController.m
//  fontTest
//
//  Created by tea on 04.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNViewController.h"
#import "OMNCalculatorVC.h"
#import "OMNRestaurant.h"
#import "OMNFuturaAssetManager.h"
#import "OMNCircleAssetManager.h"

@interface OMNViewController ()
<OMNCalculatorVCDelegate>

@end

@implementation OMNViewController {
  OMNOrder *_order;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNRestaurant *restaurant = [[OMNRestaurant alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [restaurant getOrdersForTableID:nil orders:^(NSArray *orders) {
    
    [weakSelf processOrders:orders];
    
  } error:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  }];
  
}

- (void)processOrders:(NSArray *)orders {
  _order = [orders firstObject];
}

- (void)didReceiveMemoryWarning{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (IBAction)showCalculator:(OMNAssetManager *)manager {
  
  [OMNAssetManager updateWithManager:manager];
  
  OMNCalculatorVC *calculatorVC = [[OMNCalculatorVC alloc] initWithOrder:_order];
  calculatorVC.delegate = self;
  calculatorVC.navigationItem.title = NSLocalizedString(@"Калькуляция", nil);
  [self.navigationController pushViewController:calculatorVC animated:YES];
  
}

- (IBAction)showFutura {
  [self showCalculator:[OMNFuturaAssetManager new]];
}

- (IBAction)showCircle {
  [self showCalculator:[OMNCircleAssetManager new]];
}

#pragma mark - GCalculatorVCDelegate

- (void)calculatorVC:(OMNCalculatorVC *)calculatorVC didFinishWithTotal:(double)total {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)calculatorVCDidCancel:(OMNCalculatorVC *)calculatorVC {
  
  //  [self dismissViewControllerAnimated:YES completion:nil];
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
