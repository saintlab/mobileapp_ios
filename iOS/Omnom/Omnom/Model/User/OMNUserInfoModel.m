//
//  OMNUserInfoModel.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoModel.h"
#import "OMNUserInfoItem.h"
#import "OMNBankCardsVC.h"
#import <BlocksKit+UIKit.h>
#import "OMNAuthorisation.h"
#import "OMNBankCardUserInfoItem.h"

@implementation OMNUserInfoModel {
  NSArray *_sectionItems;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _sectionItems =
    @[
      self.moneyItems,
      self.otherItems,
      self.logoutItems,
      ];
   
    NSString *token = [OMNAuthorisation authorisation].token;
    
    if (token.length) {
      __weak typeof(self)weakSelf = self;
      [OMNUser userWithToken:token user:^(OMNUser *user) {
        
        weakSelf.user = user;
        
      } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        //      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
        
      }];

    }
    
  }
  return self;
}

- (NSArray *)moneyItems {
  
  OMNUserInfoItem *cardItem = [[OMNBankCardUserInfoItem alloc] init];
  OMNUserInfoItem *promoItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"Промо-коды", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
  }];
  promoItem.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return @[cardItem, promoItem];
  
}

- (NSArray *)otherItems {
  
  OMNUserInfoItem *friendsItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"Пригласть друзей", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
  }];
  friendsItem.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  OMNUserInfoItem *helpItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"Помощь", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
  }];
  
  OMNUserInfoItem *aboutItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"О приложении", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
  }];
  aboutItem.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
  return @[friendsItem, helpItem, aboutItem];
  
}

- (NSArray *)logoutItems {
  
  OMNUserInfoItem *logoutItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"Выход", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
    UIActionSheet *logoutSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
    [logoutSheet bk_setDestructiveButtonWithTitle:NSLocalizedString(@"Выйти", nil) handler:^{
      
      [[OMNAuthorisation authorisation] logout];
      
    }];
    
    [logoutSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"Отмена", nil) handler:^{
      
      [tv deselectRowAtIndexPath:indexPath animated:YES];
      
    }];
    [logoutSheet showInView:vc.view.window];
    
  }];
  return @[logoutItem];
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSArray *rowItems = _sectionItems[section];
  return rowItems.count;
  
}

- (OMNUserInfoItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
  NSArray *rowItems = _sectionItems[indexPath.section];
  OMNUserInfoItem *userInfoItem = rowItems[indexPath.row];
  return userInfoItem;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
  }
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  [userInfoItem configureCell:cell];
  
  return cell;
}

- (void)controller:(UIViewController *)vc tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  
  if (userInfoItem.actionBlock) {
    userInfoItem.actionBlock(vc, tableView, indexPath);
  }
  else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  }
  
}

@end
