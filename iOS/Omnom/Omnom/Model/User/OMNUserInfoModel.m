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
#import "OMNFBUserInfoItem.h"
#import "OMNUserProfileCellItem.h"
#import "OMNSupportUserInfoItem.h"
#import "OMNUserLoginCellItem.h"

@implementation OMNUserInfoModel {
  
  NSArray *_sectionItems;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (void)configureTableView:(UITableView *)tableView {
  
  [OMNUserInfoHeaderView registerForTableView:tableView];
  [OMNUserProfileCellItem registerCellForTableView:tableView];
  [OMNUserInfoItem registerCellForTableView:tableView];
  tableView.dataSource = self;
  tableView.delegate = self;
  tableView.tableFooterView = [[UIView alloc] init];
  tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
}

- (void)update {
  
  if ([OMNAuthorization authorization].isAuthorized) {
    
    _sectionItems =
    @[
      self.userProfileSection,
      self.moneyItems,
      self.feedbackItems,
      self.logoutItems,
      ];

  }
  else {
    
    _sectionItems =
    @[
      self.loginSection,
      self.feedbackItems,
      ];
    
  }
  
}

- (OMNUserInfoSection *)moneyItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  NSMutableArray *moneyItems = [NSMutableArray array];
  [moneyItems addObject:[[OMNBankCardUserInfoItem alloc] init]];
  if (_restaurantMediator.showTableButton) {
  
    [moneyItems addObject:[[OMNTableUserInfoItem alloc] initWithMediator:_restaurantMediator]];
    
  }
  section.items = moneyItems;
  return section;
  
}

- (OMNUserInfoSection *)userProfileSection {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items = @[[OMNUserProfileCellItem new]];
  return section;
  
}

- (OMNUserInfoSection *)loginSection {

  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items = @[[OMNUserLoginCellItem new]];
  return section;

}

- (OMNUserInfoSection *)feedbackItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items =
  @[
    [OMNUserMailFeedbackItem new],
    [OMNSupportUserInfoItem new],
    [OMNFBUserInfoItem new],
    [OMNVersionUserInfoItem new],
    ];
  section.title = kOMN_USER_INFO_ABOUT_SECTION_TITLE;
  return section;
  
}

- (OMNUserInfoSection *)logoutItems {
  
  OMNUserInfoSection *section = [[OMNUserInfoSection alloc] init];
  section.items = @[[OMNLogoutUserInfoItem new]];
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
  
  OMNUserInfoSection *userInfoSection = _sectionItems[section];
  if (0 == userInfoSection.title.length) {
    return nil;
  }

  OMNUserInfoHeaderView *tableViewHeaderFooterView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:OMNUserInfoHeaderViewIdentifier];
  tableViewHeaderFooterView.label.text = userInfoSection.title;
  return tableViewHeaderFooterView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  OMNUserInfoSection *userInfoSection = _sectionItems[section];
  return userInfoSection.height;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNUserInfoItem *userInfoItem = [self itemAtIndexPath:indexPath];
  return [userInfoItem heightForTableView:tableView];
  
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
