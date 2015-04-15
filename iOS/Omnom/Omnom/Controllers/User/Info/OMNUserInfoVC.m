//
//  OMNUserInfoVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoVC.h"
#import "OMNAuthorization.h"
#import "OMNUserInfoModel.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNEditUserVC.h"
#import <BlocksKit+UIKit.h>

@implementation OMNUserInfoVC {
  
  OMNUserInfoModel *_userInfoModel;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"";
  self.view.backgroundColor = [UIColor whiteColor];
  _userInfoModel = [[OMNUserInfoModel alloc] initWithMediator:_restaurantMediator];
  [_userInfoModel configureTableView:self.tableView];
  
  @weakify(self)
  _userInfoModel.didSelectBlock = ^UIViewController *(UITableView *tableView, NSIndexPath *indexPath) {
    
    @strongify(self)
    return self;
    
  };
  
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  [self updateUserView];
  
}

- (void)updateUserView {

  if ([OMNAuthorization authorisation].isAuthorized) {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:kOMN_USER_INFO_CHANGE_BUTTON_TITLE style:UIBarButtonItemStylePlain target:self action:@selector(editUserTap)];
    
  }
  else {
  
    self.tableView.tableHeaderView = nil;
    self.navigationItem.rightBarButtonItem = nil;
    
  }
  
  [self.tableView reloadData];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    self.didCloseBlock();
  }
  
}

- (void)editUserTap {
  
  OMNEditUserVC *editUserVC = [[OMNEditUserVC alloc] init];
  @weakify(self)
  editUserVC.didFinishBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  [self.navigationController pushViewController:editUserVC animated:YES];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_userInfoModel reloadUserInfo];
  
}

@end
