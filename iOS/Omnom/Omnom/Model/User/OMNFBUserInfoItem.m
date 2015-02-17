//
//  OMNFBUserInfoItem.m
//  omnom
//
//  Created by tea on 23.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFBUserInfoItem.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>
#import "UIButton+omn_helper.h"
#import "OMNConstants.h"

@implementation OMNFBUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {

    self.title = NSLocalizedString(@"USER_INFO_FACEBOOK_TITLE", @"facebook/Omnom");
    self.actionBlock = ^(__weak UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath) {
      
      [tv deselectRowAtIndexPath:indexPath animated:YES];
      NSURL *facebookAppURL = [NSURL URLWithString:OMNFacebookAppUrlString];
      if ([[UIApplication sharedApplication] canOpenURL:facebookAppURL]) {
        
        [[UIApplication sharedApplication] openURL:facebookAppURL];
        
      } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:OMNFacebookPageUrlString]];
        
      }
      
    };

    self.titleColor = [OMNStyler blueColor];
    
  }
  return self;
}

- (OMNUserInfoCell *)cellForTableView:(UITableView *)tableView {
  
  OMNUserInfoCell *cell = [super cellForTableView:tableView];
  [cell.button omn_setImage:[UIImage imageNamed:@"facebook_user_icon"] withColor:self.titleColor];
  [cell.button omn_centerButtonAndImageWithSpacing:10.0f];
  return cell;
  
}

@end
