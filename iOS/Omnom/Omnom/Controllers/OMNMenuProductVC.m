//
//  OMNMenuProductVC.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductVC.h"
#import "OMNMenuProductExtendedWithRecommedtationsModel.h"
#import "UIBarButtonItem+omn_custom.h"
#import <OMNStyler.h>
#import "OMNMenuProduct+omn_edit.h"

@interface OMNMenuProductVC ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductVC {
  
  OMNMenuProduct *_menuProduct;
  OMNMenuProductExtendedWithRecommedtationsModel *_model;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator menuProduct:(OMNMenuProduct *)menuProduct products:(NSDictionary *)products {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    
    _menuProduct = menuProduct;
    _restaurantMediator = restaurantMediator;
    _model = [[OMNMenuProductExtendedWithRecommedtationsModel alloc] initWithMenuProduct:menuProduct products:products];
    
  }
  return self;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  
  [OMNMenuProductExtendedWithRecommedtationsModel registerCellsForTableView:self.tableView];
  
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.delegate = _model;
  self.tableView.dataSource = _model;
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  self.tableView.contentInset = insets;
  self.tableView.scrollIndicatorInsets = insets;

  _model.delegate = self;
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell editProduct:(OMNMenuProduct *)menuProduct {
  
  [menuProduct editMenuProductFromController:self withCompletion:^{
    
  }];
  
}

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct {
  
  
  
}

@end
