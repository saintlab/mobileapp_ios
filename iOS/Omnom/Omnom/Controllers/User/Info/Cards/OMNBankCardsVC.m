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

@interface OMNBankCardsVC ()

@end

@implementation OMNBankCardsVC {
  OMNBankCardsModel *_bankCardsModel;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupInterface];
  
  _bankCardsModel = [[OMNMailRuBankCardsModel alloc] init];
  _bankCardsModel.canDeleteCard = YES;
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    return weakSelf;
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel loadCardsWithCompletion:^{
    
    [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    
  }];
  
}

- (void)setupInterface {
  
  self.navigationItem.title = NSLocalizedString(@"Карты", nil);
  [_addCardButton setTitle:NSLocalizedString(@"Добавить карту", nil) forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _addCardButton.titleLabel.font = FuturaOSFOmnomRegular(20);
  
}

- (IBAction)addCardTap:(id)sender {
  
  [_bankCardsModel addCardFromViewController:self];
  
}

@end
