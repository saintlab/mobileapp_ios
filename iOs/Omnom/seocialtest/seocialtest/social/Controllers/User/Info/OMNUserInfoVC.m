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

@interface OMNUserInfoVC ()

@end

@implementation OMNUserInfoVC {
  OMNUserInfoModel *_userInfoModel;
  
  __weak IBOutlet UILabel *_userNameLabel;
  __weak IBOutlet UIImageView *_iconView;
  
}

- (void)dealloc {
  
  @try {
    [_userInfoModel removeObserver:self forKeyPath:NSStringFromSelector(@selector(user))];
  }
  @catch (NSException *exception) {
  }
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNUserInfoVC" bundle:nil];
  if (self) {
    _userInfoModel = [[OMNUserInfoModel alloc] init];
    [_userInfoModel addObserver:self forKeyPath:NSStringFromSelector(@selector(user)) options:NSKeyValueObservingOptionNew context:NULL];
  }
  return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([keyPath isEqualToString:NSStringFromSelector(@selector(user))]) {
    
    _userNameLabel.text = _userInfoModel.user.phone;
    [self.tableView reloadData];
    
  }
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _iconView.image = [UIImage imageNamed:@"placeholder_icon"];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(closeUserInfo)];
  
  self.tableView.dataSource = _userInfoModel;
  
}

- (void)closeUserInfo {
  
  [self.delegate userInfoVCDidFinish:self];
  
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [_userInfoModel controller:self tableView:tableView didSelectRowAtIndexPath:indexPath];
  
}

@end
