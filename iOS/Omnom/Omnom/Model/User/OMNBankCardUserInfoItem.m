//
//  OMNBankCardUserInfoItem.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardUserInfoItem.h"
#import "OMNBankCardsVC.h"
#import "OMNMailRUCardConfirmVC.h"

@interface OMNBankCardUserInfoItem ()
<OMNBankCardsVCDelegate,
OMNMailRUCardConfirmVCDelegate>

@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation OMNBankCardUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = NSLocalizedString(@"Привязать карты", nil);
    self.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    __weak typeof(self)weakSelf = self;
    [self setActionBlock:^(UIViewController *vc, UITableView *tv, NSIndexPath *indexPath) {
      
      weakSelf.rootViewController = vc;
      
      OMNBankCardsVC *bankCardsVC = [[OMNBankCardsVC alloc] init];
      bankCardsVC.delegate = weakSelf;
      [vc.navigationController pushViewController:bankCardsVC animated:YES];
      
    }];
  }
  return self;
}

#pragma mark - OMNBankCardsVCDelegate

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didCreateCard:(OMNBankCardInfo *)bankCardInfo {
  
  OMNMailRUCardConfirmVC *mailRUCardConfirmVC = [[OMNMailRUCardConfirmVC alloc] initWithCardInfo:bankCardInfo];
  mailRUCardConfirmVC.delegate = self;
  [bankCardsVC.navigationController pushViewController:mailRUCardConfirmVC animated:YES];
  
}

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didSelectCard:(OMNBankCard *)bankCard {
  
}

- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC {
  
  [self.rootViewController.navigationController popToViewController:self.rootViewController animated:YES];
  
}

#pragma mark - OMNMailRUCardConfirmVCDelegate

- (void)mailRUCardConfirmVCDidFinish:(OMNMailRUCardConfirmVC *)mailRUCardConfirmVC {
  
  [self.rootViewController.navigationController popToViewController:self.rootViewController animated:YES];
  
}

@end
