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
#import "OMNVisitor.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNUserInfoVC ()
<OMNEditTableVCDelegate>

@end

@implementation OMNUserInfoVC {
  OMNUserInfoModel *_userInfoModel;
  
  __weak IBOutlet UILabel *_userNameLabel;
  __weak IBOutlet UIButton *_iconView;

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
  
  NSString *name = (_userInfoModel.user.name.length) ? (_userInfoModel.user.name) : (@"no name");
  NSString *emailPhone = [NSString stringWithFormat:@"%@\n%@", _userInfoModel.user.email, _userInfoModel.user.phone];
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
  [self.tableView reloadData];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.title = @"";
  
  _userInfoModel = [[OMNUserInfoModel alloc] initWithVisitor:_visitor];
  self.tableView.dataSource = _userInfoModel;
  self.tableView.delegate = _userInfoModel;
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [_userInfoModel addObserver:self forKeyPath:NSStringFromSelector(@selector(user)) options:NSKeyValueObservingOptionNew context:NULL];
  __weak typeof(self)weakSelf = self;
  _userInfoModel.didSelectBlock = ^UIViewController *(UITableView *tableView, NSIndexPath *indexPath) {
    
    return weakSelf;
    
  };
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  [_iconView setBackgroundImage:[UIImage imageNamed:@"avatar_circle"] forState:UIControlStateNormal];
  [_iconView setImage:[UIImage imageNamed:@"ic_default_user"] forState:UIControlStateNormal];
  _iconView.userInteractionEnabled = NO;
  
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
  
}

- (void)closeTap {
  
  [self.delegate userInfoVCDidFinish:self];
  
}

- (void)editUserTap {
  
  
  
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

- (void)iconTap {
  
  UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Отмена", nil) destructiveButtonTitle:nil otherButtonTitles:
                          NSLocalizedString(@"Сделать снимок", nil),
                          NSLocalizedString(@"Выбрать из библиотеки", nil),
                          nil];
  [sheet showInView:self.view.window];
  
}

@end
