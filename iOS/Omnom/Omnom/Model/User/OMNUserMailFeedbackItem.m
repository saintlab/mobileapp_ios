//
//  OMNUserMailFeedbackItem.m
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserMailFeedbackItem.h"
#import <MessageUI/MessageUI.h>

@interface OMNUserMailFeedbackItem ()
<MFMailComposeViewControllerDelegate>

@end

@implementation OMNUserMailFeedbackItem

- (instancetype)init {
  self = [super init];
  if (self) {

    self.title = NSLocalizedString(@"Обратная связь", nil);
    
    __weak typeof(self)weakSelf = self;
    [self setActionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
      
      if ([MFMailComposeViewController canSendMail]) {
        
        MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] init];
        composeViewController.mailComposeDelegate = weakSelf;
        [composeViewController setToRecipients:@[@"team@omnom.menu"]];
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

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
  
  [controller.presentingViewController dismissViewControllerAnimated:YES completion:nil];
  
}

@end
