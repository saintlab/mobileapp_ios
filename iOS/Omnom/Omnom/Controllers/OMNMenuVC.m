//
//  OMNMenuVC.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuVC.h"
#import "OMNMenuModel.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNMenuCategoryVC.h"

@interface OMNMenuVC ()

@end

@implementation OMNMenuVC {
  
  OMNMenuModel *_menuModel;
  
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self omn_setup];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"back_button"] color:[UIColor whiteColor] target:self action:@selector(backTap)];
  
  __weak typeof(self)weakSelf = self;
  _menuModel.didSelectBlock = ^(OMNMenuCategory *menuCategory) {
    
    [weakSelf showMenuCategory:menuCategory];
    
  };
  
  UIEdgeInsets insets = UIEdgeInsetsMake(100.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  [self.view layoutIfNeeded];
  
}

- (void)showMenuCategory:(OMNMenuCategory *)menuCategory {
  
  self.selectedIndexPath = [_tableView indexPathForSelectedRow];
  OMNMenuCategoryVC *menuCategoryVC = [[OMNMenuCategoryVC alloc] initWithMenuCategory:menuCategory];
  __weak typeof(self)weakSelf = self;
  menuCategoryVC.didCloseBlock = ^{
    
    [weakSelf.navigationController popToViewController:weakSelf animated:YES];
    
  };
  menuCategoryVC.backgroundImage = self.backgroundImage;
  [self.navigationController pushViewController:menuCategoryVC animated:YES];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
 
  if (_tableView.indexPathForSelectedRow) {
    
    [_tableView deselectRowAtIndexPath:_tableView.indexPathForSelectedRow animated:YES];
    
  }
  
}

- (void)backTap {
  
  if (self.didCloseBlock) {
    
    self.didCloseBlock();
    
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  
  return UIStatusBarStyleLightContent;
  
}

- (void)omn_setup {
  
  UIView *fadeView = [UIView omn_autolayoutView];
  fadeView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.8f];
  [self.view addSubview:fadeView];
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_tableView];
  
  _menuModel = [[OMNMenuModel alloc] init];
  [_menuModel configureTableView:_tableView];
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"fadeView" : fadeView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    @"bottomToolbarHeight" : [OMNStyler styler].bottomToolbarHeight,
    };

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[fadeView]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
