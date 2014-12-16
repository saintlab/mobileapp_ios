//
//  OMNBankCardsModel.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAddBankCardVC.h"
#import "OMNBankCard.h"
#import "OMNBankCardCell.h"
#import "OMNBankCardInfo.h"
#import "OMNBankCardMediator.h"
#import "OMNBankCardsModel.h"
#import "OMNConstants.h"
#import "OMNOrder.h"
#import "UINavigationController+omn_replace.h"
#import <OMNStyler.h>
#import <SSKeychain.h>

NSString * const kCardIdServiceName = @"card_id";

@interface OMNBankCardsModel ()

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNBankCardsModel {
}

@dynamic card_id;

- (instancetype)initWithRootVC:(UIViewController *)vc {
  self = [super init];
  if (self) {
    
    _bankCardMediator = [[OMNBankCardMediator alloc] initWithRootVC:vc];
    
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
  return [SSKeychain passwordForService:kCardIdServiceName account:NSStringFromClass(self.class)];
}

- (void)setCard_id:(NSString *)card_id {
  
  if (card_id) {
    [SSKeychain setPassword:card_id forService:kCardIdServiceName account:NSStringFromClass(self.class)];
  }
  else {
    [SSKeychain deletePasswordForService:kCardIdServiceName account:NSStringFromClass(self.class)];
  }
  
}

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
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

- (BOOL)canAddCards {
  
  return NO;
  
}

- (void)payForOrder:(OMNOrder *)order cardInfo:(OMNBankCardInfo *)bankCardInfo completion:(dispatch_block_t)completionBlock failure:(void(^)(NSError *error, NSDictionary *debugInfo))failureBlock {
  
  //do nothing
  
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

  OMNBankCard *card = self.cards[indexPath.row];
  BOOL canEdit = (NO == card.deleting);
  
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
  
  return 50.0f;
  
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
    
    if (kOMNBankCardStatusHeld == selectedCard.status) {
      
      OMNBankCardInfo *bankCardInfo = [[OMNBankCardInfo alloc] init];
      bankCardInfo.card_id = selectedCard.external_card_id;
      [_bankCardMediator confirmCard:bankCardInfo];
      
    }
    
  }
  
}

@end
