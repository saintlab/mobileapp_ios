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

@property (nonatomic, weak) UIViewController *rootViewController;

@end

@implementation OMNBankCardUserInfoItem

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = NSLocalizedString(@"Мои привязанные карты", nil);
    self.cellAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    @weakify(self)
    [self setActionBlock:^(__weak UIViewController *vc, __weak UITableView *tv, NSIndexPath *indexPath) {
      
      @strongify(self)
      self.rootViewController = vc;
      
      OMNBankCardsVC *bankCardsVC = [[OMNBankCardsVC alloc] init];
      [vc.navigationController pushViewController:bankCardsVC animated:YES];
      
    }];
  }
  return self;
}

@end
