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

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate>

@end

@implementation OMNAddBankCardVC {
  
  __weak IBOutlet UITextField *_cardTF;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  _cardTF.keyboardType = UIKeyboardTypeDecimalPad;
  [_addCardButton setTitle:NSLocalizedString(@"Готово", nil) forState:UIControlStateNormal];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
}

- (IBAction)addCardTap:(id)sender {
  
  OMNBankCard *bankCard = [[OMNBankCard alloc] init];
  bankCard.cardNumber = _cardTF.text;
  [self.delegate addBankCardVC:self didAddCard:bankCard];
  
}

- (IBAction)scanCardTap:(id)sender {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.collectCVV = YES;
  scanViewController.collectExpiry = YES;
  scanViewController.appToken = CardIOAppToken;

  [self.presentingViewController presentViewController:scanViewController animated:YES completion:nil];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  
  NSLog(@"Scan succeeded with info: %@", info);
  // Do whatever needs to be done to deliver the purchased items.
  [self dismissViewControllerAnimated:YES completion:nil];
  
  OMNBankCard *cardInfo = [[OMNBankCard alloc] init];
  cardInfo.cardNumber = info.cardNumber;
  cardInfo.expiryMonth = info.expiryMonth;
  cardInfo.expiryYear = info.expiryYear;
  cardInfo.cvv = info.cvv;
  
  [self.delegate addBankCardVC:self didAddCard:cardInfo];
  
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"User cancelled scan");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTap {
  
  [self.delegate addBankCardVCDidCancel:self];
  
}


@end
