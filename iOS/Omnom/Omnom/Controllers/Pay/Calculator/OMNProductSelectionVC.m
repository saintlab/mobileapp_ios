//
//  GProdductSelectionVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNProductSelectionVC.h"
#import "OMNOrderDataSource.h"
#import "OMNOrder.h"
#import <BlocksKit+UIKit.h>

@interface OMNProductSelectionVC ()

@property (nonatomic, strong) OMNOrderDataSource *dataSource;

@end

@implementation OMNProductSelectionVC {
  OMNOrder *_order;
  
}


- (instancetype)initWithOrder:(OMNOrder *)order {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    _order = order;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.changedItems = [NSMutableSet set];
  
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_order];
  [_dataSource registerCellsForTableView:self.tableView];
  
  __weak typeof(self)weakSelf = self;
  [_dataSource setDidSelectBlock:^(UITableView *tv, NSIndexPath *indexPath) {
    
    OMNOrderItem *orderItem = [weakSelf.dataSource orderItemAtIndexPath:indexPath];
    if (orderItem) {
    
      if ([weakSelf.changedItems containsObject:orderItem]) {
        
        [weakSelf.changedItems removeObject:orderItem];
        
      }
      else {

        [weakSelf.changedItems addObject:orderItem];
        
      }
      
    }

    [weakSelf updateTotalValue];
    
  }];
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.dataSource = _dataSource;
  self.tableView.delegate = _dataSource;
  self.tableView.allowsMultipleSelection = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

- (void)checkConditionAndSelectProducts {
 
  static NSString *kCheckConditionAndSelectProductsKey = @"checkConditionAndSelectProducts";
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kCheckConditionAndSelectProductsKey]) {
    return;
  }
  
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCheckConditionAndSelectProductsKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSIndexPath *demoIndexPath = nil;
  
  OMNGuest *guest = [_order.guests firstObject];
  if (guest.items.count) {
    demoIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  }

  __weak typeof(self)weakSelf = self;
  UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"CALCULATOR_ALERT_TEXT", @"Отметьте ваши блюда в чеке и платите только за себя") message:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    
    [weakSelf updateIndexPath:demoIndexPath];

  }];
  
  [alert bk_setDidShowBlock:^(UIAlertView *a) {
    
    [weakSelf updateIndexPath:demoIndexPath];
    
  }];
  
}

- (void)updateIndexPath:(NSIndexPath *)indexPath {
  
  if (nil == indexPath) {
    return;
  }
  
  [_dataSource updateTableView:self.tableView atIndexPath:indexPath];
  [self updateTotalValue];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateTotalValue];
  
  [self checkConditionAndSelectProducts];
  
}

- (void)updateTotalValue {

  if ([self.delegate respondsToSelector:@selector(totalDidChange:showPaymentButton:)]) {
    
    [self.delegate totalDidChange:_order.selectedItemsTotal showPaymentButton:_order.hasSelectedItems];
    
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
