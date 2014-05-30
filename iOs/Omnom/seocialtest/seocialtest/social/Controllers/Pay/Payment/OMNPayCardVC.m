//
//  GAddCardVC.m
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPayCardVC.h"
#import <CardIO.h>
#import "GConstants.h"
#import "GCardInfo.h"

@interface OMNPayCardVC ()
<CardIOPaymentViewControllerDelegate> {

}

@end

@implementation OMNPayCardVC {
  
  __weak IBOutlet UITextField *_cardNumberTF;
  __weak IBOutlet UITextField *_expiryTF;
  __weak IBOutlet UITextField *_cvvTF;
  __weak IBOutlet UITextField *_phoneTF;
  
  GCardInfo *_cardInfo;
  
}

- (id)init {
  
  NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"cardInfo"];
  _cardInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  
  if (_cardInfo) {
    self = [super initWithNibName:@"GPaySavedCardVC" bundle:nil];
  }
  else {
    self = [super initWithNibName:@"OMNPayCardVC" bundle:nil];
  }
  
  
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Pay", nil) style:UIBarButtonItemStyleDone target:self action:@selector(payTap)];
  [self update];
  
}

- (void)payTap {
  
  if (_cardInfo) {
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:_cardInfo] forKey:@"cardInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  }
  
  if ([self.delegate respondsToSelector:@selector(payVC:requestPayWithCardInfo:)]) {
    [self.delegate payVC:self requestPayWithCardInfo:_cardInfo];
  }
  
}

- (IBAction)payCashTap:(id)sender {
  
  if ([self.delegate respondsToSelector:@selector(payVCDidPayCash:)]) {
    [self.delegate payVCDidPayCash:self];
  }
  
}

- (IBAction)scanCardTap:(id)sender {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
  scanViewController.collectCVV = YES;
  scanViewController.collectExpiry = YES;
  
  scanViewController.appToken = CardIOAppToken; // see Constants.h
  [self presentViewController:scanViewController animated:YES completion:nil];

}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)update {
  
  _cardNumberTF.text = _cardInfo.redactedCardNumber;
  if (_cardInfo) {
    _expiryTF.text = [NSString stringWithFormat:@"%02lu/%lu", (unsigned long)_cardInfo.expiryMonth, (unsigned long)_cardInfo.expiryYear];

  }
  else {
    _expiryTF.text = @"";
  }
  
  _cvvTF.text = _cardInfo.cvv;
  
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  
  NSLog(@"Scan succeeded with info: %@", info);
  // Do whatever needs to be done to deliver the purchased items.
  [self dismissViewControllerAnimated:YES completion:nil];
  
  GCardInfo *cardInfo = [[GCardInfo alloc] init];
  cardInfo.cardNumber = info.cardNumber;
  cardInfo.expiryMonth = info.expiryMonth;
  cardInfo.expiryYear = info.expiryYear;
  cardInfo.cvv = info.cvv;
  
  _cardInfo = cardInfo;
  [self update];
  
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"User cancelled scan");
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
