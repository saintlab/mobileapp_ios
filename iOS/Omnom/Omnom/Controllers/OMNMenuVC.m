//
//  OMNMenuVC.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuVC.h"
#import <OMNStyler.h>
#import "OMNMenuProductVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import "OMNMenuHeaderLabel.h"
#import "OMNMenuCategoriesModel.h"
#import "OMNMenuProductCellItem+edit.h"
#import "OMNMenuHeaderView.h"

@interface OMNMenuVC ()
<OMNMenuProductWithRecommedtationsCellDelegate>

@end

@implementation OMNMenuVC {
  
  OMNMenuCategoriesModel *_model;
  OMNRestaurantMediator *_restaurantMediator;
  __weak OMNMenuProductWithRecommendationsCellItem *_selectedItem;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _model = [[OMNMenuCategoriesModel alloc] initWithMenu:_restaurantMediator.menu delegate:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  _tableView.delegate = _model;
  _tableView.dataSource = _model;
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor whiteColor] target:self action:@selector(backTap)];
  _menuHeaderView = [[OMNMenuHeaderView alloc] init];
  [_menuHeaderView sizeToFit];
  self.navigationItem.titleView = _menuHeaderView;
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)backTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)omn_setup {
  
  self.view.backgroundColor = [UIColor clearColor];
  
  _fadeView = [UIView omn_autolayoutView];
  _fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
  [self.backgroundView addSubview:_fadeView];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.tableFooterView = [[UIView alloc] init];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];
  
  UIView *navigationFadeView = [UIView omn_autolayoutView];
  navigationFadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
  [self.view addSubview:navigationFadeView];
  
  [OMNMenuCategoriesModel registerCellsForTableView:_tableView];

  UIEdgeInsets insets = UIEdgeInsetsMake(64.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"fadeView" : _fadeView,
    @"navigationFadeView" : navigationFadeView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationFadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationFadeView(64)]" options:kNilOptions metrics:metrics views:views]];
  
  [self.view layoutIfNeeded];
  
}

#pragma mark - OMNMenuProductWithRecommedtationsCellDelegate

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectItem:(OMNMenuProductCellItem *)item {
  
  OMNMenuProductVC *menuProductVC = [[OMNMenuProductVC alloc] initWithMediator:_restaurantMediator menuProduct:item.menuProduct];
  __weak typeof(self)weakSelf = self;
  menuProductVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:menuProductVC animated:YES];
  
}

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editItem:(OMNMenuProductCellItem *)item {
  
  __weak typeof(self)weakSelf = self;
  NSIndexPath *indexPath = [_tableView indexPathForCell:menuProductWithRecommedtationsCell];
  if (indexPath) {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
  [item editMenuProductFromController:self withCompletion:^{
    
    if ([menuProductWithRecommedtationsCell.item.menuProduct isEqual:item.menuProduct]) {
      [weakSelf updateTableViewWithSelectedItem:menuProductWithRecommedtationsCell.item andScrollToCell:menuProductWithRecommedtationsCell];
    }
    
  }];
  
}

- (void)updateTableViewWithSelectedItem:(OMNMenuProductWithRecommendationsCellItem *)item andScrollToCell:(UITableViewCell *)cell {
  
  if ([_selectedItem isEqual:item]) {
    return;
  }
  
  _selectedItem.selected = NO;
  _selectedItem = item;
  _selectedItem.selected = YES;
  NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
  [_tableView beginUpdates];
  [_tableView endUpdates];
  if (indexPath) {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
}

@end
