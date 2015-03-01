//
//  OMNMenuItemVC.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryVC.h"
#import <OMNStyler.h>
#import "OMNMenuProductVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"
#import "OMNMenuHeaderLabel.h"
#import "OMNMenuCategoriesModel.h"
#import "OMNMenuProductCellItem+edit.h"

@interface OMNMenuCategoryVC ()
<OMNMenuProductWithRecommedtationsCellDelegate>

@end

@implementation OMNMenuCategoryVC {
  
  OMNMenuCategoriesModel *_model;
  OMNRestaurantMediator *_restaurantMediator;
  __weak OMNMenuProductWithRecommendationsCellItem *_selectedItem;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator category:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    _restaurantMediator = restaurantMediator;
    _model = [[OMNMenuCategoriesModel alloc] initWithMenu:_restaurantMediator.menu cellDelegate:self headerDelegate:nil];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  _tableView.delegate = _model;
  _tableView.dataSource = _model;
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor whiteColor] target:self action:@selector(backTap)];

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
  
  UIView *fadeView = [UIView omn_autolayoutView];
  fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  [self.backgroundView addSubview:fadeView];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.tableFooterView = [[UIView alloc] init];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];

  [OMNMenuCategoriesModel registerCellsForTableView:_tableView];
  
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
  
  _headerLabel = [[OMNMenuHeaderLabel alloc] init];
  _headerLabel.text = _menuCategory.name;
  [_headerLabel sizeToFit];
  self.navigationItem.titleView = _headerLabel;
  
  [self.view layoutIfNeeded];
  
}

#pragma mark - OMNMenuProductWithRecommedtationsCellDelegate

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectCell:(OMNMenuProductCell *)cell {
  
  OMNMenuProductVC *menuProductVC = [[OMNMenuProductVC alloc] initWithMediator:_restaurantMediator menuProduct:cell.item.menuProduct];
  __weak typeof(self)weakSelf = self;
  menuProductVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:menuProductVC animated:YES];
  
}

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editCell:(OMNMenuProductCell *)cell {
  
  __weak typeof(self)weakSelf = self;
  NSIndexPath *indexPath = [_tableView indexPathForCell:menuProductWithRecommedtationsCell];
  if (indexPath) {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
  [cell.item editMenuProductFromController:self withCompletion:^{
    
    if ([menuProductWithRecommedtationsCell.item.menuProduct isEqual:cell.item.menuProduct]) {
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
