//
//  OMNMenuItemVC.m
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryVC.h"
#import "OMNMenuProduct+cell.h"
#import "OMNMenuProductCell.h"
#import "OMNMenuCategory+cell.h"
#import "OMNProductModiferAlertVC.h"
#import "OMNMenuProductRecommendationsDelimiterCell.h"
#import <OMNStyler.h>
#import "OMNMenuProductsDelimiterCell.h"
#import "OMNMenuCategoryHeaderView.h"

@interface OMNMenuCategoryVC ()
<UITableViewDataSource,
UITableViewDelegate,
OMNMenuProductCellDelegate>

@end

@implementation OMNMenuCategoryVC {
  
  UITableView *_tableView;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  [self.view layoutIfNeeded];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.tableFooterView = [[UIView alloc] init];
  [_tableView registerClass:[OMNMenuProductCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductCell class])];
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
  [_tableView registerClass:[OMNMenuCategoryDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuCategoryDelimiterCell class])];
  [_tableView registerClass:[OMNMenuProductsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductsDelimiterCell class])];
  [_tableView registerClass:[OMNMenuProductRecommendationsDelimiterCell class] forCellReuseIdentifier:NSStringFromClass([OMNMenuProductRecommendationsDelimiterCell class])];
  [_tableView registerClass:[OMNMenuCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  [self.view addSubview:_tableView];
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][tableView]|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return _menuCategory.children.count;
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  OMNMenuCategory *menuCategory = _menuCategory.children[section];
  return menuCategory.listItems.count;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNMenuCategory *menuCategory = _menuCategory.children[indexPath.section];
  id listItem = menuCategory.listItems[indexPath.row];
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    UITableViewCell *cell = [listItem cellForTableView:tableView];
    
    if ([cell isKindOfClass:[OMNMenuProductCell class]]) {
      
      OMNMenuProductCell *menuProductCell = (OMNMenuProductCell *)cell;
      menuProductCell.delegate = self;
      
    }
    
    return cell;
    
  }
  else {
    
    return [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
  }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNMenuCategory *menuCategory = _menuCategory.children[indexPath.section];
  id listItem = menuCategory.listItems[indexPath.row];
  if ([listItem conformsToProtocol:@protocol(OMNMenuCellItemProtocol)]) {
    
    return [listItem heightForTableView:tableView];
    
  }
  return 100.0f;
  
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 110.0f;
  
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  
  OMNMenuCategoryHeaderView *menuCategoryHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OMNMenuCategoryHeaderView class])];
  OMNMenuCategory *menuCategory = _menuCategory.children[section];
  menuCategoryHeaderView.menuCategory = menuCategory;
  return menuCategoryHeaderView;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  
  return 45.0f;
  
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct {
  
  OMNProductModiferAlertVC *productModiferAlertVC = [[OMNProductModiferAlertVC alloc] initWithMenuProduct:menuProduct];
  __weak typeof(self)weakSelf = self;
  productModiferAlertVC.didCloseBlock = ^{
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    
  };
  productModiferAlertVC.didSelectOrderBlock = ^{
    
    [weakSelf.navigationController dismissViewControllerAnimated:YES completion:^{
      
      menuProduct.selected = YES;
      
    }];
    
  };
  [self.navigationController presentViewController:productModiferAlertVC animated:YES completion:nil];
  
}

@end
