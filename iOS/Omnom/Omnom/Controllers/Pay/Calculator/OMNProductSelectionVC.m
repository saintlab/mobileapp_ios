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
#import "OMNOrderAlertManager.h"

@interface OMNProductSelectionVC ()

@property (nonatomic, strong) OMNOrderDataSource *dataSource;

@end

@implementation OMNProductSelectionVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNVisitor *_visitor;
  BOOL _didClose;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _visitor = restaurantMediator.visitor;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
   
  _dataSource = [[OMNOrderDataSource alloc] init];
  [OMNOrderDataSource registerCellsForTableView:self.tableView];
  
  @weakify(self)
  [_dataSource setDidSelectBlock:^(UITableView *tv, NSIndexPath *indexPath) {
    
    @strongify(self)
    [self updateTotalValue];
    
  }];
  
  _dataSource.didScrollToTopBlock = ^{
    
    @strongify(self)
    [self handleClose];
    
  };
  
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.tableView.dataSource = _dataSource;
  self.tableView.delegate = _dataSource;
  self.tableView.allowsMultipleSelection = YES;
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.backgroundColor = [UIColor clearColor];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  [self updateOrder];
  
  @weakify(self)
  [OMNOrderAlertManager sharedManager].didUpdateBlock = ^{
    
    @strongify(self)
    [self updateOrder];
    
  };
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self updateTotalValue];
  [self checkConditionAndSelectProducts];
  
}

- (void)scrollToBottomWithCompletion:(dispatch_block_t)completionBlock {
  
  NSIndexPath *indexPath = _dataSource.lastIndexPath;
  if (indexPath &&
      ![self.tableView.indexPathsForVisibleRows containsObject:indexPath]) {

    [CATransaction begin];
    [CATransaction setCompletionBlock:completionBlock];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    [CATransaction commit];
    
  }
  else {
    
    completionBlock();
    
  }
  
}

- (void)handleClose {
  
  if (_didClose) {
    return;
  }
  //prevent table view scrolling back to fix animaion
  self.tableView.bounces = NO;
  _didClose = YES;
  [self.delegate calculatorVCDidCancel:nil];
  
}

- (void)updateOrder {
  
  _dataSource.order = _visitor.selectedOrder;
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
  OMNGuest *guest = [_visitor.selectedOrder.guests firstObject];
  if (guest.items.count) {
    demoIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
  }

  @weakify(self)
  UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:NSLocalizedString(@"CALCULATOR_ALERT_TEXT", @"Отметьте ваши блюда в чеке и платите только за себя") message:nil cancelButtonTitle:kOMN_OK_BUTTON_TITLE otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
    
    @strongify(self)
    [self updateIndexPath:demoIndexPath];

  }];
  
  [alert bk_setDidShowBlock:^(UIAlertView *a) {
    
    @strongify(self)
    [self updateIndexPath:demoIndexPath];
    
  }];
  
}

- (void)updateIndexPath:(NSIndexPath *)indexPath {
  
  if (!indexPath) {
    return;
  }
  
  [_dataSource updateTableView:self.tableView atIndexPath:indexPath];
  [self updateTotalValue];
  
}

- (void)updateTotalValue {

  if ([self.delegate respondsToSelector:@selector(totalDidChange:showPaymentButton:)]) {
    
    OMNOrder *order = _visitor.selectedOrder;
    [self.delegate totalDidChange:order.selectedItemsTotal showPaymentButton:order.hasSelectedItems];
    
  }
  
}

@end
