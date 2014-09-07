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
#import "OMNBorderedButton.h"

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate,
OMNCardEnterControlDelegate>

@end

@implementation OMNAddBankCardVC {
  
  OMNBankCardInfo *_cardInfo;
  
  OMNCardEnterControl *_cardEnterControl;
  UIButton *_addCardButton;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _cardInfo = [[OMNBankCardInfo alloc] init];
  
  self.navigationItem.title = @"";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Готово", nil) style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap:)];
  
  self.view.backgroundColor = [UIColor whiteColor];  
  [self setup];
  
  
  [self setRightButtonEnabled:NO];
  
}

- (void)setup {
  
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  [_cardEnterControl setSaveButtonHidden:!self.allowSaveCard];
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  
  UIView *bankCardDescriptionView = [[OMNCardBrandView alloc] init];
  [self.view addSubview:bankCardDescriptionView];
  
  _addCardButton = [[OMNBorderedButton alloc] init];
  _addCardButton.translatesAutoresizingMaskIntoConstraints = NO;
  [_addCardButton addTarget:self action:@selector(addCardTap:) forControlEvents:UIControlEventTouchUpInside];
  [_addCardButton setTitle:NSLocalizedString(@"Готово", nil) forState:UIControlStateNormal];
  _addCardButton.enabled = NO;
  _addCardButton.hidden = YES;
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
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_addCardButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

}

- (void)setRightButtonEnabled:(BOOL)enabled {
  self.navigationItem.rightBarButtonItem.enabled = enabled;
}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  
  [self setRightButtonEnabled:YES];
  _cardInfo.pan = cardData[OMNCardEnterControlPanString];
  _cardInfo.expiryMonth = [cardData[OMNCardEnterControlMonthString] integerValue];
  _cardInfo.expiryYear = [cardData[OMNCardEnterControlYearString] integerValue];
  _cardInfo.cvv = cardData[OMNCardEnterControlCVVString];
  
}

- (void)cardEnterControlDidEnterFailCardData:(OMNCardEnterControl *)control {
  [self setRightButtonEnabled:NO];
}

- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.collectCVV = NO;
  scanViewController.collectExpiry = NO;
  scanViewController.collectPostalCode = NO;
  scanViewController.disableManualEntryButtons = YES;
  scanViewController.appToken = [OMNConstants cardIOAppToken];
  [self presentViewController:scanViewController animated:YES completion:nil];
  
}

- (IBAction)addCardTap:(id)sender {

  _cardInfo.saveCard = _cardEnterControl.saveButtonSelected;
  [self.delegate addBankCardVC:self didAddCard:_cardInfo];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  
  // Do whatever needs to be done to deliver the purchased items.
  [self dismissViewControllerAnimated:YES completion:nil];
  _cardEnterControl.pan = info.cardNumber;
  _cardInfo.scanUsed = YES;
  
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelTap {
  
  [self.delegate addBankCardVCDidCancel:self];
  
}


@end
