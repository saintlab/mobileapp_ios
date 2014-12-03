//
//  OMNLogoutUserInfoItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLogoutUserInfoItem.h"
#import <BlocksKit+UIKit.h>
#import "OMNAuthorisation.h"
#import <OMNStyler.h>

@implementation OMNLogoutUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.title = NSLocalizedString(@"USER_INFO_LOGOUT_TITLE", @"Выход из аккаунта");
    self.actionBlock = ^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
      
      UIActionSheet *logoutSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
      [logoutSheet bk_setDestructiveButtonWithTitle:NSLocalizedString(@"Выйти", nil) handler:^{
        
        [[OMNAuthorisation authorisation] logout];
        
      }];
      
      [logoutSheet bk_setCancelButtonWithTitle:NSLocalizedString(@"Отмена", nil) handler:^{
        
        [tv deselectRowAtIndexPath:indexPath animated:YES];
        
      }];
      [logoutSheet showInView:vc.view.window];
      
    };
    
    self.titleColor = colorWithHexString(@"D0021B");
    self.textAlignment = NSTextAlignmentCenter;
    
  }
  return self;
}

@end
