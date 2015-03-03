//
//  OMNUserMailFeedbackItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserMailFeedbackItem.h"
#import <MessageUI/MessageUI.h>
#import <MFMailComposeViewController+BlocksKit.h>

@interface OMNUserMailFeedbackItem ()

@end

@implementation OMNUserMailFeedbackItem

- (instancetype)init {
  self = [super init];
  if (self) {

    self.title = NSLocalizedString(@"FEEDBACK_MAIL_ITEM_TITLE", @"Обратная связь");
    
    [self setActionBlock:^(UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath) {
      
      if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        [composeViewController setToRecipients:@[@"team@omnom.menu"]];
        [composeViewController setSubject:NSLocalizedString(@"FEEDBACK_MAIL_SUBJECT", @"Всё, что я думаю про Омном")];
        
        [composeViewController bk_setCompletionBlock:^(MFMailComposeViewController *mailComposeViewController, MFMailComposeResult result, NSError *error) {
          
          [mailComposeViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
          
        }];
        [vc presentViewController:composeViewController animated:YES completion:nil];
        
      }
      else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:team@omnom.menu"]];
        [tv deselectRowAtIndexPath:indexPath animated:YES];
        
      }
      
    }];

  }
  return self;
}

@end
