//
//  OMNSupportUserInfoItem.m
//  omnom
//
//  Created by tea on 16.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSupportUserInfoItem.h"
#import "OMNAuthorization.h"
#import <BlocksKit+UIKit.h>

@implementation OMNSupportUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    
    self.title = kOMN_USER_INFO_CALL_SUPPORT_TITLE;
    self.actionBlock = ^(__weak UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath) {
      
      [tv deselectRowAtIndexPath:indexPath animated:YES];
      
      [UIAlertView bk_showAlertViewWithTitle:kOMN_USER_INFO_CALL_SUPPORT_TITLE message:nil cancelButtonTitle:kOMN_CANCEL_BUTTON_TITLE otherButtonTitles:@[kOMN_CALL_BUTTON_TITLE] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (alertView.cancelButtonIndex != buttonIndex) {

          NSString *phoneNumber = [@"tel://" stringByAppendingString:[OMNAuthorization authorisation].supportPhone];
          [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];

        }
        
      }];
      
    };
    
  }
  return self;
}

- (CGFloat)heightForTableView:(UITableView *)tableView {
  return ([OMNAuthorization authorisation].supportPhone) ? (50.0f) :(0.0f);
}

@end
