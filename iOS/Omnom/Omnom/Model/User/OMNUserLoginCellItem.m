//
//  OMNUserLoginCellItem.m
//  omnom
//
//  Created by tea on 05.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNUserLoginCellItem.h"
#import "OMNLoginVC.h"
#import <OMNStyler.h>

@implementation OMNUserLoginCellItem

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.titleColor = [OMNStyler blueColor];
    self.title = kOMN_USER_INFO_LOGIN_TITLE;
    self.actionBlock = ^(__weak UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath) {
      
      [tv deselectRowAtIndexPath:indexPath animated:YES];
      OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
      [loginVC requestLogin:vc].finally(^{
        
        [vc dismissViewControllerAnimated:YES completion:nil];
        
      });
      
    };
    
  }
  return self;
}

@end
