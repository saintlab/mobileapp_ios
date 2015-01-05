//
//  OMNUserInfoVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoVC.h"
#import "OMNAuthorization.h"
#import "OMNUser.h"
#import "OMNUserInfoModel.h"
#import "OMNEditTableVC.h"
#import <OMNStyler.h>
#import "OMNRestaurant.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNEditUserVC.h"
#import "OMNUserIconView.h"
#import <BlocksKit+UIKit.h>

@interface OMNUserInfoVC ()
<OMNEditTableVCDelegate,
OMNEditUserVCDelegate>

@end

@implementation OMNUserInfoVC {
  
  OMNUserInfoModel *_userInfoModel;
  
  __weak IBOutlet UILabel *_userNameLabel;
  __weak IBOutlet OMNUserIconView *_iconView;

  UIView *_tableFooterView;

  NSString *_userObserverIdentifier;
  NSString *_userImageObserverIdentifier;
  
}

- (void)dealloc {
  
  if (_userObserverIdentifier) {
    
    [[OMNAuthorization authorisation] bk_removeObserversWithIdentifier:_userObserverIdentifier];
    _userObserverIdentifier = nil;
    
  }
  if (_userImageObserverIdentifier) {
    
    [[OMNAuthorization authorisation].user bk_removeObserversWithIdentifier:_userImageObserverIdentifier];
    _userImageObserverIdentifier = nil;
    
  }
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNUserInfoVC" bundle:nil];
  if (self) {
    
  }
  return self;
}

- (void)updateUserInfo {
  
  OMNUser *user = [OMNAuthorization authorisation].user;
  NSString *name = (user.name.length) ? (user.name) : (@"no name");
  NSString *emailPhone = [NSString stringWithFormat:@"%@\n%@", user.email, user.phone];
  NSString *text = [NSString stringWithFormat:@"%@\n%@", name, emailPhone];
  
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
  
  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : colorWithHexString(@"000000"),
     NSFontAttributeName : FuturaOSFOmnomRegular(20.0f),
     } range:[text rangeOfString:name]];

  [attributedString setAttributes:
   @{
     NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.4f],
     NSFontAttributeName : FuturaOSFOmnomRegular(15.0f),
     } range:[text rangeOfString:emailPhone]];
  
  _userNameLabel.attributedText = attributedString;
  
}

- (void)updateUserImage {
  
  [_iconView updateWithImage:[OMNAuthorization authorisation].user.image];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"";
  
  _userInfoModel = [[OMNUserInfoModel alloc] init];
  self.tableView.dataSource = _userInfoModel;
  self.tableView.delegate = _userInfoModel;
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
  OMNAuthorization *authorisation = [OMNAuthorization authorisation];
  __weak typeof(self)weakSelf = self;
  _userObserverIdentifier = [authorisation bk_addObserverForKeyPath:NSStringFromSelector(@selector(user)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    [weakSelf updateUserInfo];
    
  }];

  _userImageObserverIdentifier = [authorisation.user bk_addObserverForKeyPath:NSStringFromSelector(@selector(image)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    [weakSelf updateUserImage];
    
  }];
  
  _userInfoModel.didSelectBlock = ^UIViewController *(UITableView *tableView, NSIndexPath *indexPath) {
    
    return weakSelf;
    
  };
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _userNameLabel.numberOfLines = 3;
  _userNameLabel.backgroundColor = backgroundColor;
  _userNameLabel.opaque = YES;
  _userNameLabel.textColor = colorWithHexString(@"000000");
  _userNameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  
  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];

  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"USER_INFO_CHANGE_BUTTON_TITLE", @"Изменить") style:UIBarButtonItemStylePlain target:self action:@selector(editUserTap)];
  [self updateUserInfo];
  
  [_iconView addTarget:self action:@selector(editPhotoTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)closeTap {
  
  [self.delegate userInfoVCDidFinish:self];
  
}

- (void)editPhotoTap {
  
  [self editUserWithPhoto:YES];
  
}

- (void)editUserTap {
  
  [self editUserWithPhoto:NO];
  
}

- (void)editUserWithPhoto:(BOOL)editPhoto {
  
  OMNEditUserVC *editUserVC = [[OMNEditUserVC alloc] init];
  editUserVC.delegate = self;
  editUserVC.editPhoto = editPhoto;
  [self.navigationController pushViewController:editUserVC animated:YES];
  
}

- (void)editTableTap {
  
  OMNEditTableVC *editTableVC = [[OMNEditTableVC alloc] init];
  editTableVC.delegate = self;
  [self.navigationController pushViewController:editTableVC animated:YES];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [_userInfoModel reloadUserInfo];
  
}

#pragma mark - OMNEditTableVCDelegate

- (void)editTableVCDidFinish:(OMNEditTableVC *)editTableVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

#pragma mark - OMNEditUserVCDelegate

- (void)editUserVCDidFinish:(OMNEditUserVC *)editUserVC {
  
  [self.navigationController popToViewController:self animated:YES];
  
}

@end
