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
#import <OMNAuthorisation.h>
#import <OMNStyler.h>

@interface OMNBankCardsModel ()

@property (nonatomic, strong) NSString *card_id;

@end

@implementation OMNBankCardsModel {
  NSMutableArray *_cards;
  NSIndexPath *_selectedIndexPath;
  OMNBankCard *_selectedCard;
}

@dynamic card_id;

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (NSString *)card_id {
  return [SSKeychain passwordForService:@"card_id" account:@"mail.ru"];
}

- (void)setCard_id:(NSString *)card_id {
  [SSKeychain setPassword:card_id forService:@"card_id" account:@"mail.ru"];
}

- (OMNMailRuPaymentInfo *)selectedCardPaymentInfo {
  OMNMailRuPaymentInfo *paymentInfo = [[OMNMailRuPaymentInfo alloc] init];
  
  paymentInfo.cardInfo.card_id = _selectedCard.external_card_id;
  paymentInfo.cardInfo.cvv = @"123";
#warning paymentInfo.cardInfo.pan = @"6011000000000004"
//  if ([self.selectedCard isEqual:self.customCard]) {
//    paymentInfo.cardInfo.pan = @"4111111111111112";
//    paymentInfo.cardInfo.pan = @"6011000000000004";
//    paymentInfo.cardInfo.pan = @"639002000000000003",
//    paymentInfo.cardInfo.exp_date = @"12.2015";
//    paymentInfo.cardInfo.cvv = @"123";
//  }

  paymentInfo.user_phone = [OMNAuthorisation authorisation].user.phone;
  paymentInfo.user_login = [OMNAuthorisation authorisation].user.id;
  paymentInfo.order_message = @"message";
  
  return paymentInfo;
  
}

- (void)loadCardsWithCompletion:(dispatch_block_t)completionBlock {
  
  __weak typeof(self)weakSelf = self;
  [OMNBankCard getCardsWithCompletion:^(NSArray *cards) {
    
    [weakSelf didLoadCards:cards];
    completionBlock();
    
  } failure:^(NSError *error) {
    
    completionBlock();
    
  }];
  
}

- (void)didLoadCards:(NSArray *)cards {
  
  _cards = [cards mutableCopy];
  
  if (nil == self.card_id) {
    
    [self setNewSelectedCard];
    
  }
  else {

    __block OMNBankCard *selectedCard = nil;
    [_cards enumerateObjectsUsingBlock:^(OMNBankCard *bankCard, NSUInteger idx, BOOL *stop) {
      if ([bankCard.id isEqualToString:self.card_id]) {
        selectedCard = bankCard;
        *stop = YES;
      }
    }];
    
    if (selectedCard) {
      _selectedCard = selectedCard;
    }
    else {
      [self setNewSelectedCard];
    }
    
  }
  
}

- (void)setNewSelectedCard {
  
  if (_cards.count) {
    OMNBankCard *card = [_cards firstObject];
    self.card_id = card.id;
    _selectedCard = card;
    ;
  }
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSInteger numberOfRows = 0;
  
  switch (section) {
    case 0: {
      numberOfRows = _cards.count;
    } break;
  }
  
  return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
    cell.textLabel.textColor = [UIColor blackColor];

  }

  
  OMNBankCard *card = _cards[indexPath.row];
  
  

  UIColor *masked_panColor = nil;
  UIColor *associationColor = nil;

  if ([card isEqual:_selectedCard]) {
    _selectedIndexPath = indexPath;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected_card_icon_blue"]];
    masked_panColor = colorWithHexString(@"4A90E2");
    associationColor = [colorWithHexString(@"4A90E2") colorWithAlphaComponent:0.5f];
  }
  else {
    masked_panColor = [UIColor blackColor];
    associationColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    cell.accessoryView = nil;
  }
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@", card.masked_pan, card.association]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : masked_panColor} range:[attributedString.string rangeOfString:card.masked_pan]];
  [attributedString setAttributes:@{NSForegroundColorAttributeName : associationColor} range:[attributedString.string rangeOfString:card.association]];
  cell.textLabel.attributedText = attributedString;

  return cell;
  
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  BOOL canEdit = NO;
  if (self.canDeleteCard) {
    OMNBankCard *card = _cards[indexPath.row];
    canEdit = (NO == card.deleting);
  }
  return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBankCard *card = _cards[indexPath.row];
  NSMutableArray *cards = _cards;
  [card deleteWithCompletion:^{
    
    [cards removeObject:card];
    dispatch_async(dispatch_get_main_queue(), ^{
      [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    });

  } failure:^(NSError *error) {
  
    NSLog(@"deleteWithCompletion>%@", error);
    
  }];
  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSMutableArray *indexPaths = [@[indexPath] mutableCopy];
  
  if (_selectedIndexPath &&
      ![_selectedIndexPath isEqual:indexPath]) {
    [indexPaths addObject:_selectedIndexPath];
  }

  _selectedCard = _cards[indexPath.row];
  self.card_id = _selectedCard.id;
  
  [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
  _selectedIndexPath = indexPath;
  
  if (self.didSelectCardBlock) {
    
    OMNBankCard *card = _cards[indexPath.row];
    self.didSelectCardBlock(card);
    
  }
  
}

@end
