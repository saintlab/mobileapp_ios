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
#import <OMNStyler.h>

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate,
OMNCardEnterControlDelegate>

@end

@implementation OMNAddBankCardVC {
  
  OMNBankCardInfo *_cardInfo;
  
  OMNCardEnterControl *_cardEnterControl;
  UIButton *_addCardButton;
  UIBarButtonItem *_cardActionButton;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _cardInfo = [[OMNBankCardInfo alloc] init];
  
  self.navigationItem.title = @"";
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
  self.view.backgroundColor = [UIColor whiteColor];  
  [self setup];
  
  
  _cardActionButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(addCardTap:)];
  self.navigationItem.rightBarButtonItem = _cardActionButton;
  [self updateSubmitButton];
  [self setRightButtonEnabled:NO];
  
}

- (void)setup {
  
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  _cardEnterControl.delegate = self;
  [_cardEnterControl setSaveButtonHidden:self.hideSaveButton];
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
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cardEnterControl]-|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[bankCardDescriptionView]" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardEnterControl]-[bankCardDescriptionView]-[addCardButton]" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_addCardButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];

}

- (void)setRightButtonEnabled:(BOOL)enabled {
  
  _cardActionButton.enabled = enabled;
  
}

- (void)updateSubmitButton {
  
  NSString *title = (_cardEnterControl.saveButtonSelected) ? (NSLocalizedString(@"BANK_CARD_ADD_BUTTON_TITLE", @"Привязать")) : (NSLocalizedString(@"BANK_CARD_PAY_BUTTON_TITLE", @"Оплатить"));
  _cardActionButton.title = title;
  
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
  scanViewController.useCardIOLogo = YES;
  scanViewController.collectExpiry = NO;
  scanViewController.collectPostalCode = NO;
  scanViewController.disableManualEntryButtons = YES;
  [self presentViewController:scanViewController animated:YES completion:nil];
  
}

- (void)cardEnterControlSaveButtonStateDidChange:(OMNCardEnterControl *)control {
  
  [self updateSubmitButton];
  
}

- (IBAction)addCardTap:(id)sender {

  _cardInfo.saveCard = _cardEnterControl.saveButtonSelected;
  if (self.addCardBlock) {
    self.addCardBlock(_cardInfo);
  }
  
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
  
  if (self.cancelBlock) {
    self.cancelBlock();
  }
  
}


@end
