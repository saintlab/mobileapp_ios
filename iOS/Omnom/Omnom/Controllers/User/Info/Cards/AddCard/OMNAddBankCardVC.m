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
#import <OMNMailRuAcquiring.h>
#import "OMNSocketManager.h"
#import "OMNAuthorisation.h"

@interface OMNAddBankCardVC ()
<CardIOPaymentViewControllerDelegate,
OMNCardEnterControlDelegate>

@end

@implementation OMNAddBankCardVC {
  
  OMNBankCard *_cardInfo;
  
  OMNCardEnterControl *_cardEnterControl;
  UIButton *_addCardButton;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveCardId:) name:OMNSocketIODidReceiveCardIdNotification object:nil];
  [self setup];
}

- (void)setup {
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  
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
    };
  
  NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cardEnterControl]-|" options:0 metrics:nil views:views];
  [self.view addConstraints:panH];
  
  NSArray *panV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardEnterControl]-[addCardButton]" options:0 metrics:nil views:views];
  [self.view addConstraints:panV];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[addCardButton]|" options:0 metrics:0 views:views]];
  
  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
}

- (void)didReceiveCardId:(NSNotification *)n {
  NSLog(@"%@", n);
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

- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control {
  
  CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
  scanViewController.collectCVV = NO;
  scanViewController.collectExpiry = NO;
  scanViewController.collectPostalCode = NO;
  scanViewController.appToken = CardIOAppToken;
  [self presentViewController:scanViewController animated:YES completion:nil];
  
}

- (IBAction)addCardTap:(id)sender {

//  [self.delegate addBankCardVC:self didAddCard:_cardInfo];
  if (_cardInfo) {
    
  }

  [self registerCard];
  
}

- (void)registerCard {
  NSDictionary *cardInfo =
  @{
    @"pan" : @"4111111111111111",
    @"exp_date" : @"12.2015",
    @"cvv" : @"123",
    };
  
//    @"pan" : @"4111111111111111",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",

//    @"pan" : @"6011000000000004",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
  
//    @"pan" : @"639002000000000003",
//    @"exp_date" : @"12.2015",
//    @"cvv" : @"123",
  
  __weak typeof(self)weakSelf = self;
  OMNUser *user = [OMNAuthorisation authorisation].user;
  [[OMNMailRuAcquiring acquiring] registerCard:cardInfo user_login:user.id user_phone:user.phone completion:^(id response) {
    
    [weakSelf didFinishPostCardInfo:response];
    
  }];

}

- (void)didFinishPostCardInfo:(id)response {
  NSLog(@"registerCard>%@", response);
  if (response) {
    
  }
  else {
    
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
