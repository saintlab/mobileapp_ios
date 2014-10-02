//
//  OMNBankCardsModel.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardsModel.h"
#import "OMNConstants.h"
#import <SSKeychain.h>
#import "OMNAuthorisation.h"
#import <OMNStyler.h>
#import "OMNBankCardCell.h"
#import "OMNMailRUCardConfirmVC.h"
#import "OMNAddBankCardVC.h"

@interface OMNBankCardsModel ()

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNBankCardsModel {
  NSIndexPath *_selectedIndexPath;
}

@dynamic card_id;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (NSString *)card_id {
  return [SSKeychain passwordForService:@"card_id" account:@"demo"];
}

- (void)setCard_id:(NSString *)card_id {
  [SSKeychain setPassword:card_id forService:@"card_id" account:@"demo"];
}

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
  OMNBankCard *bankCard = [[OMNBankCard alloc] init];
  bankCard.id = @"1";
  bankCard.association = @"visa";
  bankCard.masked_pan = @"4111 .... .... 1111";
  _cards = [NSMutableArray arrayWithObject:bankCard];
  [self updateCardSelection];
  completionBlock();
  
}

- (void)updateCardSelection {
  
  if (self.cards.count) {
    OMNBankCard *card = [self.cards firstObject];
    self.card_id = card.id;
    self.selectedCard = card;
  }
  
}

- (void)removeCard:(OMNBankCard *)bankCard {
  if ([self.card_id isEqualToString:bankCard.id]) {
    self.card_id = nil;
  }
  [self.cards removeObject:bankCard];
  [self updateCardSelection];
}

- (void)addCardFromViewController:(__weak UIViewController *)viewController {
  
  OMNAddBankCardVC *addBankCardVC = [[OMNAddBankCardVC alloc] init];
  __weak typeof(self)weakSelf = self;
  [addBankCardVC setAddCardBlock:^(OMNBankCardInfo *bankCardInfo) {
    
    [weakSelf confirmCard:bankCardInfo sourceVC:viewController];
    
  }];
  [addBankCardVC setCancelBlock:^{
    
    [viewController.navigationController popToViewController:viewController animated:YES];
    
  }];
  [viewController.navigationController pushViewController:addBankCardVC animated:YES];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      numberOfRows = self.cards.count;
    } break;
  }
  
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"cellIdentifier";
  OMNBankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (nil == cell) {
    cell = [[OMNBankCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  OMNBankCard *card = self.cards[indexPath.row];
  BOOL selected = [card isEqual:self.selectedCard];
  
  if (selected) {
    _selectedIndexPath = indexPath;
  }
  
  [cell setBankCard:card selected:selected];

  return cell;
  
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  BOOL canEdit = NO;
  if (self.canDeleteCard) {
    OMNBankCard *card = self.cards[indexPath.row];
    canEdit = (NO == card.deleting);
  }
  return canEdit;
}

- (UIActivityIndicatorView *)spinner {
  UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  [spinner startAnimating];
  return spinner;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBankCard *card = self.cards[indexPath.row];
  __weak typeof(self)weakSelf = self;
  __weak UITableView *weakTableView = tableView;
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  cell.accessoryView = [self spinner];
  
  [card deleteWithCompletion:^{
    
    [weakSelf removeCard:card];
    if (weakTableView) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
      });
    }

  } failure:^(NSError *error) {
  
    [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
  }];
  
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
  return NSLocalizedString(@"CARD_DELETE_BUTTON_TITLE", @"Удалить");
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBankCard *selectedCard = self.cards[indexPath.row];

  if (kOMNBankCardStatusRegistered == selectedCard.status) {
    
    NSMutableArray *indexPaths = [@[indexPath] mutableCopy];
    
    if (_selectedIndexPath &&
        ![_selectedIndexPath isEqual:indexPath]) {
      [indexPaths addObject:_selectedIndexPath];
    }
    
    self.selectedCard = selectedCard;
    self.card_id = self.selectedCard.id;
    
    [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    _selectedIndexPath = indexPath;
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  }
  
  if (self.didSelectCardBlock) {
    
    UIViewController *vc = self.didSelectCardBlock(selectedCard);
    if (vc &&
        kOMNBankCardStatusHeld == selectedCard.status) {
      
      OMNBankCardInfo *bankCardInfo = [[OMNBankCardInfo alloc] init];
      bankCardInfo.card_id = selectedCard.external_card_id;
      [self confirmCard:bankCardInfo sourceVC:vc];
      
    }
    
  }
  
}

- (void)confirmCard:(OMNBankCardInfo *)bankCardInfo sourceVC:(__weak UIViewController *)sourceVC {
  
  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  mailRUCardConfirmVC.didFinishBlock = ^{
    [sourceVC.navigationController popToViewController:sourceVC animated:YES];
  };
  [sourceVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

@end
