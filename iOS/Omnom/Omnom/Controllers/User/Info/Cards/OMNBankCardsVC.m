//
//  OMNBankCardsVC.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardsVC.h"
#import "OMNBankCardsModel.h"
#import "OMNConstants.h"
#import "OMNMailRuBankCardsModel.h"
#import <BlocksKit.h>
#import "OMNMailRuPaymentFactory.h"
#import "OMNBankCard+omn_info.h"

@interface OMNBankCardsVC ()

@property (nonatomic, strong) OMNBankCardMediator *bankCardMediator;

@end

@implementation OMNBankCardsVC {
  
  OMNBankCardsModel *_bankCardsModel;

  __weak IBOutlet UIButton *_addCardButton;
  NSString *_bankCardsLoadingIdentifier;

}

- (void)removeBankCardsObserver {
  
  if (_bankCardsLoadingIdentifier) {
    [_bankCardsModel bk_removeObserversWithIdentifier:_bankCardsLoadingIdentifier];
  }
  
}

- (void)dealloc {
  
  [self removeBankCardsObserver];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupInterface];
  
  OMNMailRuPaymentFactory *paymentFactory = [[OMNMailRuPaymentFactory alloc] init];
  self.bankCardMediator = [paymentFactory bankCardMediatorWithRootVC:self transaction:nil];
  
  _bankCardsModel = self.bankCardMediator.bankCardsModel;
  
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
  
  _bankCardsLoadingIdentifier = [_bankCardsModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(loading)) options:NSKeyValueObservingOptionNew task:^(OMNMailRuBankCardsModel *obj, NSDictionary *change) {
    
    (obj.loading) ? ([spinner startAnimating]) : ([spinner stopAnimating]);
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  @weakify(self)
  [_bankCardsModel loadCardsWithCompletion:^{
    
    @strongify(self)
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
  }];
  
}

- (void)setupInterface {
  
  self.navigationItem.title = NSLocalizedString(@"Карты", nil);
  [_addCardButton setTitle:NSLocalizedString(@"Добавить карту", nil) forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _addCardButton.titleLabel.font = FuturaOSFOmnomRegular(20);
  
}

- (IBAction)addCardTap:(id)sender {
  
  [_bankCardMediator registerCard];
  
}

@end
