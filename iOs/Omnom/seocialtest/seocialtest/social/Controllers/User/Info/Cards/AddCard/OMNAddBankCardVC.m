//
//  OMNAddBankCardsVC.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAddBankCardVC.h"
#import <CardIO.h>
#import "OMNConstants.h"
#import <OMNCardEnterControl.h>

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate,
OMNCardEnterControlDelegate>

@end

@implementation OMNAddBankCardVC {
  
  OMNBankCard *_cardInfo;
  
  OMNCardEnterControl *_cardEnterControl;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.center = CGPointMake(CGRectGetWidth(self.view.frame)/2.0f, 100.0f);
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  
  [_addCardButton setTitle:NSLocalizedString(@"Готово", nil) forState:UIControlStateNormal];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  
  _cardInfo = [[OMNBankCard alloc] init];
  _cardInfo.cardNumber = cardData[OMNCardEnterControlPanString];
  _cardInfo.expiryMonth = [cardData[OMNCardEnterControlMonthString] integerValue];
  _cardInfo.expiryYear = [cardData[OMNCardEnterControlYearString] integerValue];
  _cardInfo.cvv = cardData[OMNCardEnterControlCVVString];
  
  [control endEditing:YES];
}

- (IBAction)addCardTap:(id)sender {
  
  if (_cardInfo) {
    [self.delegate addBankCardVC:self didAddCard:_cardInfo];
  }
  
}

- (IBAction)scanCardTap:(id)sender {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.collectCVV = YES;
  scanViewController.collectExpiry = YES;
  scanViewController.appToken = CardIOAppToken;

  [self presentViewController:scanViewController animated:YES completion:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  
  NSLog(@"Scan succeeded with info: %@", info);
  // Do whatever needs to be done to deliver the purchased items.
  [self dismissViewControllerAnimated:YES completion:nil];
  
  _cardInfo = [[OMNBankCard alloc] init];
  _cardInfo.cardNumber = info.cardNumber;
  _cardInfo.expiryMonth = info.expiryMonth;
  _cardInfo.expiryYear = info.expiryYear;
  _cardInfo.cvv = info.cvv;

  
  
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"User cancelled scan");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTap {
  
  [self.delegate addBankCardVCDidCancel:self];
  
}


@end
