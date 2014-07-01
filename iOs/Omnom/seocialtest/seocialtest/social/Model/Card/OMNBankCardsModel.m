//
//  OMNBankCardsModel.m
//  seocialtest
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardsModel.h"
#import "OMNConstants.h"

@implementation OMNBankCardsModel {
  NSMutableArray *_cards;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _cards = [NSMutableArray array];
  }
  return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _cards.count;
}

- (void)addBankCard:(OMNBankCard *)bankCard {
  
  [_cards addObject:bankCard];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *cellIdentifier = @"cellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.font = FuturaMediumFont(20);
    cell.textLabel.textColor = [UIColor whiteColor];

    cell.detailTextLabel.font = FuturaMediumFont(15);
    cell.detailTextLabel.textColor = [UIColor lightGrayColor];

  }
  
  OMNBankCard *card = _cards[indexPath.row];
  cell.textLabel.text = card.name;
  cell.detailTextLabel.text = @"visa";
  return cell;
  
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [_cards removeObjectAtIndex:indexPath.row];
  [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
  
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (self.didSelectCardBlock) {
    
    OMNBankCard *card = _cards[indexPath.row];
    self.didSelectCardBlock(card);
    
  }
}

@end
