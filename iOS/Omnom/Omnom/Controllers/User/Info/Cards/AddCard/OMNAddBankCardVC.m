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
#import "OMNAuthorisation.h"
#import "OMNCardBrandView.h"

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate,
OMNCardEnterControlDelegate>

@end

@implementation OMNAddBankCardVC {
  
  OMNBankCardInfo *_cardInfo;
  
  OMNCardEnterControl *_cardEnterControl;
  UIButton *_addCardButton;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  self.view.backgroundColor = [UIColor whiteColor];  
  [self setup];
}

- (void)setup {
  
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  [_cardEnterControl setSaveButtonHidden:!self.allowSaveCard];
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  
  UIView *bankCardDescriptionView = [[OMNCardBrandView alloc] init];
  [self.view addSubview:bankCardDescriptionView];
  
  _addCardButton = [[UIButton alloc] init];
  _addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
  _addCardButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  [_addCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
  [_addCardButton addTarget:self action:@selector(addCardTap:) forControlEvents:UIControlEventTouchUpInside];
  [_addCardButton setTitle:NSLocalizedString(@"Готово", nil) forState:UIControlStateNormal];
  [self.view addSubview:_addCardButton];
  
  NSDictionary *views =
  @{
    @"cardEnterControl" : _cardEnterControl,
    @"topLayoutGuide" : self.topLayoutGuide,
    @"addCardButton" : _addCardButton,
    @"bankCardDescriptionView" : bankCardDescriptionView,
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cardEnterControl]-|" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[bankCardDescriptionView]" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardEnterControl]-[bankCardDescriptionView]-[addCardButton]" options:0 metrics:nil views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[addCardButton]|" options:0 metrics:0 views:views]];

}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  
  _cardInfo = [[OMNBankCardInfo alloc] init];
  _cardInfo.pan = cardData[OMNCardEnterControlPanString];
  _cardInfo.expiryMonth = [cardData[OMNCardEnterControlMonthString] integerValue];
  _cardInfo.expiryYear = [cardData[OMNCardEnterControlYearString] integerValue];
  _cardInfo.cvv = cardData[OMNCardEnterControlCVVString];
  [control endEditing:YES];
  
}

- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.collectCVV = NO;
  scanViewController.collectExpiry = NO;
  scanViewController.collectPostalCode = NO;
  scanViewController.appToken = CardIOAppToken;
  [self presentViewController:scanViewController animated:YES completion:nil];
  
}

- (IBAction)addCardTap:(id)sender {

  if (_cardInfo) {
    _cardInfo.saveCard = _cardEnterControl.saveButtonSelected;
    [self.delegate addBankCardVC:self didAddCard:_cardInfo];
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  
  NSLog(@"Scan succeeded with info: %@", info);
  // Do whatever needs to be done to deliver the purchased items.
  [self dismissViewControllerAnimated:YES completion:nil];
  
  _cardEnterControl.pan = info.cardNumber;
  
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  NSLog(@"User cancelled scan");
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTap {
  
  [self.delegate addBankCardVCDidCancel:self];
  
}


@end
