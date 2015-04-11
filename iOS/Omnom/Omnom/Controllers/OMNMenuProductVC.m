//
//  OMNMenuProductVC.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>
#import "OMNMenuProductFullWithRecommendationsCellItem.h"
#import "OMNMenuProductCellItem+edit.h"

@interface OMNMenuProductVC ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductVC {
  
  OMNMenuProduct *_menuProduct;
  OMNMenuProductFullWithRecommendationsCellItem *_menuProductFullWithRecommendations;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator menuProduct:(OMNMenuProduct *)menuProduct {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    
    _menuProduct = menuProduct;
    _restaurantMediator = restaurantMediator;
    _menuProductFullWithRecommendations = [[OMNMenuProductFullWithRecommendationsCellItem alloc] initWithMenuProduct:menuProduct products:restaurantMediator.menu.products];
    
  }
  return self;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  [OMNMenuProductFullWithRecommendationsCellItem registerProductWithRecommendationsCellForTableView:self.tableView];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.delegate = _menuProductFullWithRecommendations;
  self.tableView.dataSource = _menuProductFullWithRecommendations;
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  self.tableView.contentInset = insets;
  self.tableView.scrollIndicatorInsets = insets;

  _menuProductFullWithRecommendations.productItemDelegate = self;
  
  [self.navigationItem setHidesBackButton:YES animated:NO];
  self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (OMNMenuProductFullCell *)rootCell {

  return (OMNMenuProductFullCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell {
  [menuProductCell.item editMenuProductFromController:self withCompletion:^{}];
}

- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell {
  //do nothing
}

@end
