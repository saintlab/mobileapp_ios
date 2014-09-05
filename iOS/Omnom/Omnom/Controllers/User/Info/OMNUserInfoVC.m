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
#import "OMNToolbarButton.h"

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
    _userInfoModel = [[OMNUserInfoModel alloc] init];
    [_userInfoModel addObserver:self forKeyPath:NSStringFromSelector(@selector(user)) options:NSKeyValueObservingOptionNew context:NULL];
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(user))]) {
    
    _userNameLabel.text = [NSString stringWithFormat:@"%@\n%@\n%@", _userInfoModel.user.name, _userInfoModel.user.email, _userInfoModel.user.phone];
    [self.tableView reloadData];
    
  }
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"";
  
  [_pinButton setImage:[UIImage imageNamed:@"table_marker_icon"] forState:UIControlStateNormal];
  _pinButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  [_pinButton setTitle:_visitor.table.internal_id forState:UIControlStateNormal];
  
  [_iconView setBackgroundImage:[UIImage imageNamed:@"green_circle_big"] forState:UIControlStateNormal];
//  [_iconView setImage:[UIImage imageNamed:@"add_photo_button_icon"] forState:UIControlStateNormal];
  
  [_logoutButton setBackgroundImage:[UIImage imageNamed:@"bottom_rectangle"] forState:UIControlStateNormal];
  [_logoutButton setTitle:NSLocalizedString(@"Выход из аккаунта", nil) forState:UIControlStateNormal];
  _logoutButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  [_logoutButton setTitleColor:colorWithHexString(@"D0021B") forState:UIControlStateNormal];
  [_logoutButton addTarget:self action:@selector(logoutTap) forControlEvents:UIControlEventTouchUpInside];
  _userNameLabel.numberOfLines = 3;
  _userNameLabel.textColor = colorWithHexString(@"000000");
  _userNameLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  
  self.tableView.dataSource = _userInfoModel;

  self.navigationController.navigationBar.shadowImage = [UIImage new];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
  
//  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Стол", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editTableTap)];
//  self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
//  
//  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Изменить", nil) style:UIBarButtonItemStylePlain target:self action:@selector(editUserTap)];
//  self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];

  UIButton *closeButton = [[OMNToolbarButton alloc] initWithImage:[UIImage imageNamed:@"cross_icon_black"] title:nil];
  [closeButton addTarget:self action:@selector(closeTap) forControlEvents:UIControlEventTouchUpInside];
  self.navigationItem.titleView = closeButton;
  
  [self.view addSubview:_logoutButton];
  UIEdgeInsets inset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(_logoutButton.frame), 0.0f);
  self.tableView.contentInset = inset;
  self.tableView.scrollIndicatorInsets = inset;
  
}

- (void)logoutTap {
  
  UIActionSheet *logoutSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
  [logoutSheet bk_setDestructiveButtonWithTitle:NSLocalizedString(@"Выйти", nil) handler:^{
    
    [[OMNAuthorisation authorisation] logout];
    
  }];
  [logoutSheet bk_addButtonWithTitle:NSLocalizedString(@"Отмена", nil) handler:nil];
  [logoutSheet showInView:self.view.window];
  
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  CGRect frame = _logoutButton.frame;
  frame.origin.y = CGRectGetHeight(scrollView.frame) + scrollView.contentOffset.y - CGRectGetHeight(frame);
  _logoutButton.frame = frame;
  
}

@end
