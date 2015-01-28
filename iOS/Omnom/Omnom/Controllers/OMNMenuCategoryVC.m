//
//  OMNMenuItemVC.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryVC.h"
#import "OMNProductModiferAlertVC.h"
#import <OMNStyler.h>
#import "OMNMenuProductVC.h"
#import "OMNMenuCategoryModel.h"
#import "OMNCategoryNavigationView.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"

@interface OMNMenuCategoryVC ()
<OMNMenuProductWithRecommedtationsCellDelegate>

@end

@implementation OMNMenuCategoryVC {
  
  OMNMenuCategoryModel *_model;
  __weak OMNMenuProduct *_menuProductSelectionItem;
  
}

- (instancetype)initWithMenuCategory:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    _model = [[OMNMenuCategoryModel alloc] initWithMenuCategory:menuCategory delegate:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  [self.view layoutIfNeeded];
  _tableView.delegate = _model;
  _tableView.dataSource = _model;
  
//  [self.navigationController.navigationBar setBackgroundImage:self.backgroundImage forBarMetrics:UIBarMetricsDefault];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor whiteColor] target:self action:@selector(backTap)];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  OMNCategoryNavigationView *categoryNavigationView = [[OMNCategoryNavigationView alloc] init];
  categoryNavigationView.category = _menuCategory;
  self.navigationItem.titleView = categoryNavigationView;
  
}

- (void)backTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (void)omn_setup {
  
  UIView *fadeView = [UIView omn_autolayoutView];
  fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  [self.backgroundView addSubview:fadeView];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.tableFooterView = [[UIView alloc] init];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];

  [OMNMenuCategoryModel registerCellsForTableView:_tableView];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"fadeView" : fadeView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][tableView]|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - OMNMenuProductWithRecommedtationsCellDelegate

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectMenuProduct:(OMNMenuProduct *)menuProduct {
  
  OMNMenuProductVC *menuProductVC = [[OMNMenuProductVC alloc] initWithMenuProduct:menuProduct products:_menuCategory.allProducts];
  __weak typeof(self)weakSelf = self;
  menuProductVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:menuProductVC animated:YES];
  
}

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editMenuProduct:(OMNMenuProduct *)menuProduct {
  
  if ([menuProductWithRecommedtationsCell.model.menuProduct isEqual:menuProduct]) {
    
    [self updateTableViewWithSelectedItems:menuProduct andScrollToCell:menuProductWithRecommedtationsCell];
    
  }
  
  OMNProductModiferAlertVC *productModiferAlertVC = [[OMNProductModiferAlertVC alloc] initWithMenuProduct:menuProduct];
  __weak typeof(self)weakSelf = self;
  productModiferAlertVC.didCloseBlock = ^{
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  
  productModiferAlertVC.didSelectOrderBlock = ^{
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self.navigationController presentViewController:productModiferAlertVC animated:YES completion:nil];
  
}

- (void)updateTableViewWithSelectedItems:(OMNMenuProduct *)menuProduct andScrollToCell:(UITableViewCell *)cell {
  
  _menuProductSelectionItem.selected = NO;
  _menuProductSelectionItem = menuProduct;
  _menuProductSelectionItem.selected = YES;
  
  NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
  [_tableView beginUpdates];
  [_tableView endUpdates];
  [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
}


@end
