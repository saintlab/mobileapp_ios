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

@interface OMNBankCardsVC ()
<OMNAddBankCardVCDelegate>

@end

@implementation OMNBankCardsVC {
  OMNBankCardsModel *_bankCardsModel;
  __weak IBOutlet UIButton *_addCardButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self setupInterface];
  
  _bankCardsModel = [[OMNBankCardsModel alloc] init];
  __weak typeof(self)weakSelf = self;
  [_bankCardsModel setDidSelectCardBlock:^(OMNBankCard *bankCard) {
    
    [weakSelf.delegate bankCardsVC:weakSelf didSelectCard:bankCard];
    
  }];
  
  self.tableView.dataSource = _bankCardsModel;
  self.tableView.delegate = _bankCardsModel;
  
}

- (void)setupInterface {
  
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_blur"]];
  
  [_addCardButton setTitle:NSLocalizedString(@"Добавить карту", nil) forState:UIControlStateNormal];
  [_addCardButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  _addCardButton.titleLabel.font = FuturaMediumFont(20);
}

- (IBAction)addCardTap:(id)sender {
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  addBankCardVC.delegate = self;
  
  [self.navigationController pushViewController:addBankCardVC animated:YES];
  
}

#pragma mark - OMNAddBankCardVCDelegate

- (void)addBankCardVC:(OMNAddBankCardVC *)addBankCardVC didAddCard:(OMNBankCard *)card {
  
  [_bankCardsModel addBankCard:card];
  [self.tableView reloadData];
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)addBankCardVCDidCancel:(OMNAddBankCardVC *)addBankCardVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}



@end
