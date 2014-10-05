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
#import "OMNOrder.h"
#import "OMNPaymentAlertVC.h"
#import "UINavigationController+omn_replace.h"

@interface OMNBankCardsModel ()

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNBankCardsModel {
  OMNOrder *_order;
  OMNBankCardInfoBlock _paymentWithCardBlock;
}

@dynamic card_id;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (OMNBankCard *)selectedCard {
  
  __block OMNBankCard *selectedCard = nil;
  NSArray *cards = [self.cards copy];
  [cards enumerateObjectsUsingBlock:^(OMNBankCard *card, NSUInteger idx, BOOL *stop) {
    
    if ([card.id isEqualToString:self.card_id]) {
      selectedCard = card;
      *stop = YES;
    }
    
  }];
  
  return selectedCard;
  
}

- (NSString *)card_id {
  return [SSKeychain passwordForService:@"card_id" account:@"demo"];
}

- (void)setCard_id:(NSString *)card_id {
  
  if (card_id) {
    [SSKeychain setPassword:card_id forService:@"card_id" account:@"demo"];
  }
  else {
    [SSKeychain deletePasswordForService:@"card_id" account:@"demo"];
  }
  
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
  
  if (self.selectedCard) {
    return;
  }
  
  [self.cards enumerateObjectsUsingBlock:^(OMNBankCard *card, NSUInteger idx, BOOL *stop) {
    
    if (kOMNBankCardStatusRegistered == card.status) {
      self.card_id = card.id;
      *stop = YES;
    }
    
  }];
  
}

- (void)removeCard:(OMNBankCard *)bankCard {
  if ([self.card_id isEqualToString:bankCard.id]) {
    self.card_id = nil;
  }
  [self.cards removeObject:bankCard];
  [self updateCardSelection];
}

- (BOOL)hasRegisterdCards {
  
  __block BOOL hasRegisterdCards = NO;
  [self.cards enumerateObjectsUsingBlock:^(OMNBankCard *card, NSUInteger idx, BOOL *stop) {
    
    if (kOMNBankCardStatusRegistered == card.status) {
      hasRegisterdCards = YES;
      *stop = YES;
    }
    
  }];
  
  return hasRegisterdCards;
  
}

- (void)addCardFromViewController:(__weak UIViewController *)viewController forOrder:(OMNOrder *)order requestPaymentWithCard:(OMNBankCardInfoBlock)paymentWithCardBlock {
  
  _order = order;
  _paymentWithCardBlock = paymentWithCardBlock;
  
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
  BOOL selected = [card.id isEqualToString:self.card_id];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBankCard *card = self.cards[indexPath.row];
  if (card.deleting) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  __weak UITableView *weakTableView = tableView;
  [tableView setEditing:NO animated:YES];
  [card deleteWithCompletion:^{
    
    [weakSelf removeCard:card];
    [weakTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

  } failure:^(NSError *error) {
    
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
    
    self.card_id = selectedCard.id;
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  }
  
  if (self.didSelectCardBlock &&
      NO == self.loading &&
      NO == selectedCard.deleting) {
    
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

  long long enteredAmountWithTips = _order.enteredAmountWithTips;
  NSString *alertText = NSLocalizedString(@"NO_SMS_ALERT_TEXT", @"Вероятно, SMS-уведомления не подключены. Нужно посмотреть последнее списание в банковской выписке и узнать сумму.");
  NSString *alertConfirmText = (_order) ? (NSLocalizedString(@"NO_SMS_ALERT_ACTION_TEXT", @"Если посмотреть сумму списания сейчас возможности нет, вы можете однократно оплатить сумму без привязки карты.")) : (nil);
  
  mailRUCardConfirmVC.noSMSBlock = ^{
    
    OMNPaymentAlertVC *paymentAlertVC = [[OMNPaymentAlertVC alloc] initWithText:alertText detailedText:alertConfirmText amount:enteredAmountWithTips];
    [sourceVC.navigationController presentViewController:paymentAlertVC animated:YES completion:nil];
    
    paymentAlertVC.didCloseBlock = ^{
      
      [sourceVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      
    };
    
    paymentAlertVC.didPayBlock = ^{
      
      [sourceVC.navigationController dismissViewControllerAnimated:YES completion:nil];
      
      if (_paymentWithCardBlock) {
        _paymentWithCardBlock(bankCardInfo);
      }
      
    };
    
  };
  
  [sourceVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

@end
