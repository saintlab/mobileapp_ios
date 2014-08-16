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

@interface OMNBankCardsVC ()
<OMNAddBankCardVCDelegate,
OMNMailRUCardConfirmVCDelegate>

@end

@implementation OMNBankCardsVC {
  OMNBankCardsModel *_bankCardsModel;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupInterface];
  
  _bankCardsModel = [[OMNBankCardsModel alloc] init];
  _bankCardsModel.canDeleteCard = YES;
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    [weakSelf.delegate bankCardsVC:weakSelf didSelectCard:bankCard];
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel loadCardsWithCompletion:^{
    
    [weakSelf.tableView reloadData];
    
  }];
  
}

- (void)setupInterface {
  
  [_addCardButton setTitle:NSLocalizedString(@"Добавить карту", nil) forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _addCardButton.titleLabel.font = FuturaBookFont(20);
  
}

- (IBAction)addCardTap:(id)sender {
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.allowSaveCard = self.allowSaveCard;
  addBankCardVC.delegate = self;
  [self.navigationController pushViewController:addBankCardVC animated:YES];
  
}

#pragma mark - OMNAddBankCardVCDelegate

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCardInfo *)bankCardInfo {

  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  mailRUCardConfirmVC.delegate = self;
  [self.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNMailRUCardConfirmVCDelegate

- (void)mailRUCardConfirmVCDidFinish:(OMNMailRUCardConfirmVC *)mailRUCardConfirmVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
