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
  
  OMNRestaurantMediator *_restaurantMediator;
  BOOL _didClose;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
   
  _dataSource = [[OMNOrderDataSource alloc] initWithOrder:_restaurantMediator.selectedOrder];
  [_dataSource registerCellsForTableView:self.tableView];
  
  __weak typeof(self)weakSelf = self;
  [_dataSource setDidSelectBlock:^(UITableView *tv, NSIndexPath *indexPath) {
    
    [weakSelf updateTotalValue];
    
  }];
  
  _dataSource.didScrollToTopBlock = ^{
    
//    [weakSelf handleClose];
    
  };
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.dataSource = _dataSource;
  self.tableView.delegate = _dataSource;
  self.tableView.allowsMultipleSelection = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderDidChange:) name:OMNOrderDidChangeNotification object:nil];

}

- (void)handleClose {
  
  if (_didClose) {
    return;
  }
  _didClose = YES;
  [self.delegate calculatorVCDidCancel:nil];
  
}

- (void)orderDidChange:(NSNotification *)n {
  
  [self.tableView reloadData];
  [self updateTotalValue];
  
}

- (void)checkConditionAndSelectProducts {
 
  static NSString *kCheckConditionAndSelectProductsKey = @"checkConditionAndSelectProducts";
  if ([[NSUserDefaults standardUserDefaults] boolForKey:kCheckConditionAndSelectProductsKey]) {
    return;
  }
  
  [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kCheckConditionAndSelectProductsKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  
  NSIndexPath *demoIndexPath = nil;
  OMNGuest *guest = [_restaurantMediator.selectedOrder.guests firstObject];
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
  
  if (!indexPath) {
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
    
    OMNOrder *order = _restaurantMediator.selectedOrder;
    [self.delegate totalDidChange:order.selectedItemsTotal showPaymentButton:order.hasSelectedItems];
    
  }
  
}

@end
