//
//  OMNPreorderConfirmVC.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMyOrderConfirmVC.h"
#import "OMNPreorderConfirmCell.h"
#import "OMNPreorderActionCell.h"
#import "UIView+screenshot.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNMenu+wish.h"
#import "OMNTable+omn_network.h"
#import <OMNStyler.h>
#import <BlocksKit+UIKit.h>
#import "OMNWishMediator.h"
#import "UIBarButtonItem+omn_custom.h"

#import "OMNMyOrderConfirmModel.h"

@interface OMNMyOrderConfirmVC ()
<OMNPreorderActionCellDelegate,
OMNPreorderConfirmCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong, readonly) OMNMyOrderConfirmModel *model;
@property (nonatomic, strong, readonly) OMNWishMediator *wishMediator;;

@end

@implementation OMNMyOrderConfirmVC {
  
  OMNRestaurantMediator *_restaurantMediator;
  NSString *_loadingObserverID;
  
}

- (void)dealloc {
  
  if (_loadingObserverID) {
    [_model bk_removeObserversWithIdentifier:_loadingObserverID];
  }
  
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    _wishMediator = [_restaurantMediator wishMediatorWithRootVC:self];
    _model = [[OMNMyOrderConfirmModel alloc] initWithWishMediator:_wishMediator actionDelegate:self preorderDelegate:self];
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self omn_setup];
  
  [_model configureTableView:_tableView];
  
  @weakify(self)
  _model.reloadSectionsBlock = ^(NSIndexSet *indexes, BOOL animated) {
    
    @strongify(self)
    if (animated) {
      [self.tableView reloadSections:indexes withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else {
      [self.tableView reloadData];
    }
    
  };
  _loadingObserverID = [_model bk_addObserverForKeyPath:NSStringFromSelector(@selector(loading)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(OMNMyOrderConfirmModel *obj, NSDictionary *change) {
    
    @strongify(self)
    [self.navigationItem setRightBarButtonItem:(obj.loading) ? ([UIBarButtonItem omn_loadingItem]) : (nil) animated:YES];
    
  }];
  
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithTitle:kOMN_CLOSE_BUTTON_TITLE color:[UIColor whiteColor] target:self action:@selector(closeTap)];
  [self setupBottomBar];

}

- (void)setupBottomBar {
  
  UIButton *button = [_wishMediator bottomButton];
  if (!button) {
    return;
  }
  
  UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, [OMNStyler styler].bottomToolbarHeight.floatValue, 0.0f);
  _tableView.contentInset = insets;
  _tableView.scrollIndicatorInsets = insets;
  
  [self addActionBoardIfNeeded];
  
  self.bottomToolbar.hidden = NO;
  self.bottomToolbar.items =
  @[
    [UIBarButtonItem omn_flexibleItem],
    [[UIBarButtonItem alloc] initWithCustomView:button],
    [UIBarButtonItem omn_flexibleItem],
    ];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [_model updatePreorderedProductsAnimated:NO];
  [_model loadTableProductItemsWithCompletion:^{}];
  [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"upper_bar_wish"] forBarMetrics:UIBarMetricsDefault];

}

- (void)closeTap {
  
  if (self.didFinishBlock) {
    self.didFinishBlock();
  }
  
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}


#pragma mark - OMNPreorderActionCellDelegate

- (void)preorderActionCellDidOrder:(OMNPreorderActionCell *)preorderActionCell {
  
  @weakify(self)
  [_model preorderItemsWithCompletion:^(OMNVisitor *wishVisitor) {
    
    if (wishVisitor) {

      @strongify(self)
      [self.wishMediator processCreatedWishForVisitor:wishVisitor];
      
    }
    
  }];
  
}

- (void)preorderActionCellDidRefresh:(OMNPreorderActionCell *)preorderActionCell {
  
  preorderActionCell.refreshButton.enabled = NO;
  [_model loadTableProductItemsWithCompletion:^{
    
    preorderActionCell.refreshButton.enabled = YES;
    
  }];
  
}

- (void)preorderActionCellDidClear:(OMNPreorderActionCell *)preorderActionCell {
  
  [_restaurantMediator.menu removePreorderedItems];
  [_model updatePreorderedProductsAnimated:YES];
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_tableView];
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{};
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide][tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view layoutIfNeeded];
  
}

#pragma mark - OMNPreorderConfirmCellDelegate

- (void)preorderConfirmCellDidEdit:(OMNPreorderConfirmCell *)preorderConfirmCell {
  
  @weakify(self)
  [preorderConfirmCell.item editMenuProductFromController:self withCompletion:^{
    
    @strongify(self)
    [self.model updatePreorderedProductsAnimated:YES];
    
  }];
  
}

@end
