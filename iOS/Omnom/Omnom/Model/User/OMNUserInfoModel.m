//
//  OMNUserInfoModel.m
//  seocialtest
//
//  Created by tea on 25.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorization.h"
#import "OMNBankCardUserInfoItem.h"
#import "OMNBankCardsVC.h"
#import "OMNUser+network.h"
#import "OMNUserInfoSection.h"
#import "OMNUserInfoModel.h"
#import <BlocksKit+UIKit.h>
#import <OMNStyler.h>
#import "OMNUserMailFeedbackItem.h"
#import "OMNUserInfoHeaderView.h"
#import "OMNTableUserInfoItem.h"
#import "OMNVersionUserInfoItem.h"
#import "OMNLogoutUserInfoItem.h"

@interface OMNUserInfoModel ()

@end

@implementation OMNUserInfoModel {
  NSArray *_sectionItems;
  OMNVisitor *_visitor;
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super init];
  if (self) {
    
    _visitor = visitor;
    _sectionItems =
    @[
      self.moneyItems,
      [self feedbackItems],
      self.logoutItems,
      ];
    
    [self reloadUserInfo];
    
  }
  return self;
}

- (void)reloadUserInfo {
  
  [[OMNAuthorization authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {

  }];

}

- (OMNUserInfoSection *)moneyItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items =
  @[
    [[OMNBankCardUserInfoItem alloc] init],
    [[OMNTableUserInfoItem alloc] initWithTable:_visitor.table],
    ];
  
  return section;
  
}

- (OMNUserInfoSection *)feedbackItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items =
  @[
    [[OMNUserMailFeedbackItem alloc] init],
    [[OMNVersionUserInfoItem alloc] init],
    ];
  section.title = NSLocalizedString(@"USER_INFO_ABOUT_SECTION_TITLE", @"О ПРОГРАММЕ");
  return section;
  
}

- (OMNUserInfoSection *)logoutItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items =
  @[
    [[OMNLogoutUserInfoItem alloc] init],
    ];
  return section;
  
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _sectionItems.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  OMNUserInfoSection *userInfoSection = _sectionItems[section];
  return userInfoSection.items.count;
  
}

- (OMNUserInfoItem *)itemAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNUserInfoSection *userInfoSection = _sectionItems[indexPath.section];
  OMNUserInfoItem *userInfoItem = userInfoSection.items[indexPath.row];
  return userInfoItem;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  return [userInfoItem cellForTableView:tableView];

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  static NSString * const headerFooterViewWithIdentifier = @"headerFooterViewWithIdentifier";
  OMNUserInfoHeaderView *tableViewHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerFooterViewWithIdentifier];
  if (nil == tableViewHeaderFooterView) {
    
    tableViewHeaderFooterView = [[OMNUserInfoHeaderView alloc] initWithReuseIdentifier:headerFooterViewWithIdentifier];

  }
  OMNUserInfoSection *userInfoSection = _sectionItems[section];
  tableViewHeaderFooterView.label.text = userInfoSection.title;
  
  return tableViewHeaderFooterView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  OMNUserInfoSection *userInfoSection = _sectionItems[section];
  return userInfoSection.height;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  return userInfoItem.height;
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath  {
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  if (self.didSelectBlock &&
      userInfoItem.actionBlock) {
    
    UIViewController *vc = self.didSelectBlock(tableView, indexPath);
    userInfoItem.actionBlock(vc, tableView, indexPath);
    
  }
  else {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
  }
  
}

@end
