//
//  OMNLogoutUserInfoItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLogoutUserInfoItem.h"
#import <BlocksKit+UIKit.h>
#import "OMNAuthorization.h"
#import <OMNStyler.h>

@implementation OMNLogoutUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.title = kOMN_USER_INFO_LOGOUT_BUTTON_TITLE;
    self.actionBlock = ^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
      
      UIActionSheet *logoutSheet = [UIActionSheet bk_actionSheetWithTitle:nil];
      [logoutSheet bk_setDestructiveButtonWithTitle:kOMN_EXIT_BUTTON_TITLE handler:^{
        
        [[OMNAuthorization authorization] logout];
        
      }];
      
      [logoutSheet bk_setCancelButtonWithTitle:kOMN_CANCEL_BUTTON_TITLE handler:^{
        
        [tv deselectRowAtIndexPath:indexPath animated:YES];
        
      }];
      [logoutSheet showInView:vc.view.window];
      
    };
    
    self.titleColor = [OMNStyler redColor];
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
  }
  return self;
}

@end
