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
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

    cell.textLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
    cell.textLabel.textColor = [UIColor blackColor];

  }

  
  OMNBankCard *card = self.cards[indexPath.row];

  UIColor *masked_panColor = nil;
  UIColor *associationColor = nil;

  if ([card isEqual:self.selectedCard]) {
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
    OMNBankCard *card = self.cards[indexPath.row];
    canEdit = (NO == card.deleting);
  }
  return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBankCard *card = self.cards[indexPath.row];
  __weak typeof(self)weakSelf = self;
  __weak UITableView *weakTableView = tableView;
  [card deleteWithCompletion:^{
    
    [weakSelf removeCard:card];
    if (weakTableView) {
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakTableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
      });
    }

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

  self.selectedCard = self.cards[indexPath.row];
  self.card_id = self.selectedCard.id;
  
  [tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
  _selectedIndexPath = indexPath;
  
  if (self.didSelectCardBlock) {
    
    OMNBankCard *card = self.cards[indexPath.row];
    self.didSelectCardBlock(card);
    
  }
  
}

@end
