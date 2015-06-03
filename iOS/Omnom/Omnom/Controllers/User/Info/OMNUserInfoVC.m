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
  
  NSString *_supportPhoneObserverID;
  NSString *_userObserverID;
  
}

- (void)dealloc {
  
  if (_supportPhoneObserverID) {
    [[OMNAuthorization authorization] bk_removeObserversWithIdentifier:_supportPhoneObserverID];
  }
  if (_userObserverID) {
    [[OMNAuthorization authorization] bk_removeObserversWithIdentifier:_userObserverID];
  }
  
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
  
  [[OMNAuthorization authorization] loadSupport];
  
  _supportPhoneObserverID = [[OMNAuthorization authorization] bk_addObserverForKeyPath:NSStringFromSelector(@selector(supportPhone)) options:(NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self update];
    
  }];
  _userObserverID = [[OMNAuthorization authorization] bk_addObserverForKeyPath:NSStringFromSelector(@selector(user)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self update];

  }];
  
}

- (UIBarButtonItem *)editUserButton {
  return [UIBarButtonItem omn_barButtonWithTitle:kOMN_USER_INFO_CHANGE_BUTTON_TITLE color:[UIColor blackColor] target:self action:@selector(editUserTap)];
}

- (void)update {

  self.navigationItem.rightBarButtonItem = ([OMNAuthorization authorization].isAuthorized) ? ([self editUserButton]) : (nil);
  [_userInfoModel update];
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
  
  [[OMNAuthorization authorization] checkAuthenticationToken].catch(^(id error) {
    
  });
  
}

@end
