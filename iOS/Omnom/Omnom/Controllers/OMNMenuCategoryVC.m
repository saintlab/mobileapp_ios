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
#import "OMNMenuCategoryModel.h"
#import "OMNCategoryNavigationView.h"
#import "UIBarButtonItem+omn_custom.h"
#import "UIView+omn_autolayout.h"

@interface OMNMenuCategoryVC ()
<OMNMenuProductWithRecommedtationsCellDelegate>

@end

@implementation OMNMenuCategoryVC {
  
  OMNMenuCategoryModel *_model;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator category:(OMNMenuCategory *)menuCategory {
  self = [super init];
  if (self) {
    
    _menuCategory = menuCategory;
    _restaurantMediator = restaurantMediator;
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

  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor whiteColor] target:self action:@selector(backTap)];

}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  OMNCategoryNavigationView *categoryNavigationView = [[OMNCategoryNavigationView alloc] init];
  categoryNavigationView.category = _menuCategory;
  self.navigationItem.titleView = categoryNavigationView;
  
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
  
  OMNMenuProductVC *menuProductVC = [[OMNMenuProductVC alloc] initWithMediator:_restaurantMediator menuProduct:menuProduct products:_menuCategory.allProducts];
  __weak typeof(self)weakSelf = self;
  menuProductVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  [self.navigationController pushViewController:menuProductVC animated:YES];
  
}

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editMenuProduct:(OMNMenuProduct *)menuProduct {
  
  __weak typeof(self)weakSelf = self;
  [_restaurantMediator editMenuProduct:menuProduct withCompletion:^{

    if ([menuProductWithRecommedtationsCell.model.menuProduct isEqual:menuProduct]) {
      
      [weakSelf updateTableViewWithSelectedItems:menuProduct andScrollToCell:menuProductWithRecommedtationsCell];
      
    }
    
  }];
  
}

- (void)updateTableViewWithSelectedItems:(OMNMenuProduct *)menuProduct andScrollToCell:(UITableViewCell *)cell {
  
  [_restaurantMediator.menu deselectAllProducts];
  menuProduct.selected = (menuProduct.quantity > 0.0);
  
  NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
  [_tableView beginUpdates];
  [_tableView endUpdates];
  [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  
}


@end
