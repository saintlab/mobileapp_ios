//
//  OMNBankCardUserInfoItem.m
//  omnom
//
//  Created by tea on 12.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBankCardUserInfoItem.h"
#import "OMNBankCardsVC.h"

@interface OMNBankCardUserInfoItem ()
<OMNBankCardsVCDelegate>

@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation OMNBankCardUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = NSLocalizedString(@"Мои привязанные карты", nil);
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

- (void)bankCardsVC:(OMNBankCardsVC *)bankCardsVC didSelectCard:(OMNBankCard *)bankCard {
  
}

- (void)bankCardsVCDidCancel:(OMNBankCardsVC *)bankCardsVC {
  
  [self.rootViewController.navigationController popToViewController:self.rootViewController animated:YES];
  
}

@end
