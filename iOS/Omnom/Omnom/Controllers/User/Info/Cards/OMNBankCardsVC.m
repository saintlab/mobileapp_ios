//
//  OMNBankCardsVC.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardsVC.h"
#import "OMNBankCardsModel.h"
#import "OMNAddBankCardVC.h"
#import "OMNConstants.h"
#import "OMNMailRUCardConfirmVC.h"
#import "OMNMailRuBankCardsModel.h"
#import <BlocksKit.h>
#import "OMNBankCardMediator.h"

NSString * const OMNBankCardsVCLoadingIdentifier = @"OMNBankCardsVCLoadingIdentifier";

@interface OMNBankCardsVC ()

@end

@implementation OMNBankCardsVC {
  OMNBankCardsModel *_bankCardsModel;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)dealloc {
  
  [_bankCardsModel bk_removeObserversWithIdentifier:OMNBankCardsVCLoadingIdentifier];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupInterface];
  
  _bankCardsModel = [[OMNMailRuBankCardsModel alloc] init];
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    return weakSelf;
    
  }];

  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:spinner];
  
  [_bankCardsModel bk_addObserverForKeyPath:NSStringFromSelector(@selector(loading)) identifier:OMNBankCardsVCLoadingIdentifier options:NSKeyValueObservingOptionNew task:^(OMNMailRuBankCardsModel *obj, NSDictionary *change) {
    
    (obj.loading) ? ([spinner startAnimating]) : ([spinner stopAnimating]);
    
  }];
  
  self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel loadCardsWithCompletion:^{
    
    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
  }];
  
}

- (void)setupInterface {
  
  self.navigationItem.title = NSLocalizedString(@"Карты", nil);
  [_addCardButton setTitle:NSLocalizedString(@"Добавить карту", nil) forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _addCardButton.titleLabel.font = FuturaOSFOmnomRegular(20);
  
}

- (IBAction)addCardTap:(id)sender {
  
  [_bankCardsModel.bankCardMediator addCardForOrder:nil requestPaymentWithCard:nil];
  
}

@end
