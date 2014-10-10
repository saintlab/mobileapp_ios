//
//  OMNUserInfoVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoVC.h"
#import "OMNAuthorisation.h"
#import "OMNUser.h"
#import "OMNUserInfoModel.h"
#import "OMNEditTableVC.h"
#import <OMNStyler.h>
#import <BlocksKit+UIKit.h>
#import "OMNVisitor.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNUserInfoVC ()
<OMNEditTableVCDelegate>

@end

@implementation OMNUserInfoVC {
  OMNUserInfoModel *_userInfoModel;
  
  __weak IBOutlet UILabel *_userNameLabel;
  __weak IBOutlet UIButton *_iconView;
  IBOutlet UIButton *_logoutButton;
  __weak IBOutlet UIButton *_pinButton;
  UIView *_tableFooterView;
  OMNVisitor *_visitor;
  __weak IBOutlet UILabel *_versionLabel;
}

- (void)dealloc {
  
  @try {
    [_userInfoModel removeObserver:self forKeyPath:NSStringFromSelector(@selector(user))];
  }
  @catch (NSException *exception) {
  }
  
}

- (instancetype)initWithVisitor:(OMNVisitor *)visitor {
  self = [super initWithNibName:@"OMNUserInfoVC" bundle:nil];
  if (self) {
    _visitor = visitor;
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(user))]) {
    
    [self updateUserInfo];
    
  }
  
}

- (void)updateUserInfo {
  _userNameLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", _userInfoModel.user.name, _userInfoModel.user.email, _userInfoModel.user.phone];
  [self.tableView reloadData];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"";
  
  _userInfoModel = [[OMNUserInfoModel alloc] init];
  [_userInfoModel addObserver:self forKeyPath:NSStringFromSelector(@selector(user)) options:NSKeyValueObservingOptionNew context:NULL];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  _versionLabel.textAlignment = NSTextAlignmentCenter;
  _versionLabel.backgroundColor = backgroundColor;
  _versionLabel.opaque = YES;
  _versionLabel.font = FuturaLSFOmnomLERegular(15.0f);
  _versionLabel.text = [NSString stringWithFormat:@"version %@ build %@", CURRENT_VERSION, CURRENT_BUILD];
  _versionLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  
  [_pinButton setTitleColor:[UIColor colorWithWhite:135.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
  [_pinButton setImage:[UIImage imageNamed:@"table_marker_icon"] forState:UIControlStateNormal];
  _pinButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_pinButton setTitle:_visitor.table.internal_id forState:UIControlStateNormal];
  _pinButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 5.0f, 0.0f, 0.0f);
  
  [_iconView setBackgroundImage:[UIImage imageNamed:@"green_circle_big"] forState:UIControlStateNormal];
//  [_iconView setImage:[UIImage imageNamed:@"add_photo_button_icon"] forState:UIControlStateNormal];

  _userNameLabel.numberOfLines = 3;
  _userNameLabel.backgroundColor = backgroundColor;
  _userNameLabel.opaque = YES;
  _userNameLabel.textColor = colorWithHexString(@"000000");
  _userNameLabel.font = FuturaLSFOmnomLERegular(20.0f);
  
  self.tableView.dataSource = _userInfoModel;

  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  self.navigationItem.titleView = [UIBarButtonItem omn_buttonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
  [self updateUserInfo];
  
  _pinButton.hidden = (nil == _visitor);
  
}

- (void)closeTap {
  [self.delegate userInfoVCDidFinish:self];
}

- (void)editTableTap {
  
  OMNEditTableVC *editTableVC = [[OMNEditTableVC alloc] init];
  editTableVC.delegate = self;
  [self.navigationController pushViewController:editTableVC animated:YES];
  
}

#pragma mark - OMNEditTableVCDelegate

- (void)editTableVCDidFinish:(OMNEditTableVC *)editTableVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)editUserTap {
  
}

- (void)iconTap {
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Отмена", nil) destructiveButtonTitle:nil otherButtonTitles:
                          NSLocalizedString(@"Сделать снимок", nil),
                          NSLocalizedString(@"Выбрать из библиотеки", nil),
                          nil];
  [sheet showInView:self.view.window];
  
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  UIView *view = [[UIView alloc] init];
  view.backgroundColor = [UIColor clearColor];
  return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [_userInfoModel controller:self tableView:tableView didSelectRowAtIndexPath:indexPath];
  
}

@end
