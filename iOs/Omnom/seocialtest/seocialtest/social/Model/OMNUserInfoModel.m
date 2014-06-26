//
//  OMNUserInfoModel.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoModel.h"
#import "OMNUserInfoItem.h"

@implementation OMNUserInfoModel {
  NSArray *_sectionItems;
}

- (instancetype)init {
  self = [super init];
  if (self) {
  
    __weak typeof(self)weakSelf = self;
    [OMNUser userWithToken:[OMNAuthorisation authorisation].token user:^(OMNUser *user) {
      
      weakSelf.user = user;
      
    } failure:^(NSError *error) {
      
      NSLog(@"%@", error);
//      [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
      
    }];
    
    _sectionItems =
  @[
    self.moneyItems,
    self.otherItems,
    self.logoutItems,
    ];
    
  }
  return self;
}

- (NSArray *)moneyItems {
  
  OMNUserInfoItem *cardItem = [OMNUserInfoItem itemWithTitle:NSLocalizedString(@"Привязать карты", nil) actionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
    
  }];
  cardItem.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
  
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
    
    [OMNAuthorisation authorisation].logoutCallback();
    
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
