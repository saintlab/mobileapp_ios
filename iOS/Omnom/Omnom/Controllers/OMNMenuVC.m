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
#import "OMNMenuCategorySectionItem.h"
#import "UIView+screenshot.h"
#import <BlocksKit.h>
#import "OMNMenuSearchVC.h"
#import "UINavigationBar+omn_custom.h"

@interface OMNMenuVC ()
<OMNMenuProductWithRecommedtationsCellDelegate,
OMNMenuCategoryHeaderViewDelegate>

@property (nonatomic, strong, readonly) OMNMenuCategoriesModel *model;

@end

@implementation OMNMenuVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  OMNMenuCategory *_initiallySelectedCategory;
  __weak OMNMenuProductWithRecommendationsCellItem *_selectedItemWithRecommendations;
  
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator selectedCategory:(OMNMenuCategory *)selectedCategory {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _initiallySelectedCategory = selectedCategory;
    _model = [[OMNMenuCategoriesModel alloc] initWithMenu:_restaurantMediator.menu cellDelegate:self headerDelegate:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  _tableView.delegate = _model;
  _tableView.dataSource = _model;
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor whiteColor] target:self action:@selector(backTap)];
  self.navigationItem.rightBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"ic_search_black"] color:[UIColor whiteColor] target:self action:@selector(searchTap)];
  
  @weakify(self)
  _model.didEndDraggingBlock = ^(UITableView *tableView) {
    
    if (tableView.contentOffset.y < -100.0f) {
      
      @strongify(self)
      [self backTap];
      
    }
    
  };
  
  [_model updateWithCompletion:^(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes) {
    
    @strongify(self)
    [self.tableView reloadData];
    
  }];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidReset) name:OMNMenuDidResetNotification object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  [self.navigationController.navigationBar omn_setTransparentBackground];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  _navigationFadeView.image = [self.view omn_screenshotWithBounds:_navigationFadeView.bounds];
 
  if (!_initiallySelectedCategory) {
    return;
  }
  NSString *selectedCategoryId = _initiallySelectedCategory.id;
  _initiallySelectedCategory = nil;
  OMNMenuCategorySectionItem *selectedItem = [_model.allCategories bk_match:^BOOL(OMNMenuCategorySectionItem *item) {
    
    return [item.menuCategory.id isEqualToString:selectedCategoryId];
    
  }];
  
  if (selectedItem) {
    [self selectMenuCategorySectionItem:selectedItem];
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)searchTap {
  
  OMNMenuSearchVC *menuSearchVC = [[OMNMenuSearchVC alloc] initWithMenu:_restaurantMediator.menu];
  [self.navigationController pushViewController:menuSearchVC animated:YES];
  
}

- (void)menuDidReset {
  
  _selectedItemWithRecommendations.selected = NO;
  _selectedItemWithRecommendations = nil;
  [self.tableView reloadData];

}

- (void)closeAllCategoriesWithCompletion:(dispatch_block_t)completionBlock {
  
  @weakify(self)
  [_model closeAllCategoriesWithCompletion:^(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes) {
    
    @strongify(self)
    [self.tableView beginUpdates];
    [self.tableView deleteSections:deletedIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), completionBlock);
    
  }];
  
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
  
  _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
  _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
  _tableView.tableHeaderView = [[OMNMenuHeaderView alloc] init];
  _tableView.tableHeaderView.userInteractionEnabled = NO;
  _tableView.backgroundColor = [UIColor clearColor];
  _tableView.tableFooterView = [[UIView alloc] init];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];
  
  _navigationFadeView = [UIImageView omn_autolayoutView];
  _navigationFadeView.clipsToBounds = YES;
  [self.view addSubview:_navigationFadeView];
  
  [OMNMenuCategoriesModel registerCellsForTableView:_tableView];

  UIEdgeInsets insets = UIEdgeInsetsMake(64.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"fadeView" : _fadeView,
    @"navigationFadeView" : _navigationFadeView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"topOffset" : @(64.0f),
    };

  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.backgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
//  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
//  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[navigationFadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[navigationFadeView(topOffset)]" options:kNilOptions metrics:metrics views:views]];
  
  [self.view layoutIfNeeded];
  
}

#pragma mark - OMNMenuProductWithRecommedtationsCellDelegate

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell didSelectCell:(OMNMenuProductCell *)cell {
  
  self.selectedCell = cell;
  OMNMenuProductVC *menuProductVC = [[OMNMenuProductVC alloc] initWithMediator:_restaurantMediator menuProduct:cell.item.menuProduct];
  @weakify(self)
  menuProductVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.navigationController popToViewController:self animated:YES];
    
  };
  [self.navigationController pushViewController:menuProductVC animated:YES];
  
}

- (void)menuProductWithRecommedtationsCell:(OMNMenuProductWithRecommedtationsCell *)menuProductWithRecommedtationsCell editCell:(OMNMenuProductCell *)cell {
  
  NSIndexPath *indexPath = [_tableView indexPathForCell:menuProductWithRecommedtationsCell];
  if (indexPath) {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
  @weakify(self)
  [cell.item editMenuProductFromController:self withCompletion:^{
    
    @strongify(self)
    if ([menuProductWithRecommedtationsCell.item.menuProduct isEqual:cell.item.menuProduct]) {
      [self updateTableViewWithSelectedItem:menuProductWithRecommedtationsCell.item andScrollToCell:menuProductWithRecommedtationsCell];
    }
    
  }];
  
}

- (void)updateTableViewWithSelectedItem:(OMNMenuProductWithRecommendationsCellItem *)item andScrollToCell:(UITableViewCell *)cell {

  _selectedItemWithRecommendations.selected = NO;
  _selectedItemWithRecommendations = item;
  _selectedItemWithRecommendations.selected = YES;
  NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
  [_tableView beginUpdates];
  [_tableView endUpdates];
  if (indexPath) {
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
  }
  
}

#pragma mark - OMNMenuCategoryHeaderViewDelegate

- (void)menuCategoryHeaderViewDidSelect:(OMNMenuCategoryHeaderView *)menuCategoryHeaderView {
  [self selectMenuCategorySectionItem:menuCategoryHeaderView.menuCategorySectionItem];
}

- (void)selectMenuCategorySectionItem:(OMNMenuCategorySectionItem *)selectedSectionItem {
  
  @weakify(self)
  [_model selectMenuCategoryItem:selectedSectionItem withCompletion:^(NSIndexSet *deletedIndexes, NSIndexSet *insertedIndexes, NSIndexSet *reloadIndexes, NSArray *deletedCells, NSArray *insertedCells) {
    
    @strongify(self)
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:deletedCells withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:insertedCells withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView deleteSections:deletedIndexes withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertSections:insertedIndexes withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
    
    NSInteger selectedIndex = [self.model.visibleCategories indexOfObject:selectedSectionItem];
    if (NSNotFound != selectedIndex &&
        selectedSectionItem.rowItems.count) {
      
      [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedIndex] atScrollPosition:UITableViewScrollPositionTop animated:YES];
      
    }

  }];
  
}

@end
