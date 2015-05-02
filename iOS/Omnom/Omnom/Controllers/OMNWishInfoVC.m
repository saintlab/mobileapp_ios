//
//  OMNWishInfoVC.m
//  omnom
//
//  Created by tea on 27.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWishInfoVC.h"
#import "OMNWishCell.h"
#import "OMNWishStatusCell.h"
#import "NSString+omn_json.h"
#import "OMNMenu.h"
#import <BlocksKit.h>
#import "OMNWish+omn_network.h"
#import "OMNNavigationController.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNError.h"
#import "OMNCircleRootVC.h"
#import "UINavigationController+omn_replace.h"
#import "UIImage+omn_helper.h"
#import <OMNStyler.h>

@implementation OMNWishInfoVC {
  NSArray *_items;
  NSString *_wishID;
}

- (instancetype)initWithWishID:(NSString *)wishID {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    _wishID = wishID;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
 
  [self omn_setup];
  [self loadWish];
  
}

- (void)loadWish {
  
  [OMNWish wishWithID:_wishID].then(^(OMNWish *wish) {
    
    [self didLoadWish:wish];
    
    
  }).catch(^(OMNError *error) {
    
    [self didFailWithError:error];
    
  });

}

- (void)didFailWithError:(OMNError *)error {
  
  OMNCircleRootVC *repeatVC = [[OMNCircleRootVC alloc] initWithParent:nil];
  repeatVC.backgroundImage = [UIImage imageNamed:@"wood_bg"];
  repeatVC.text = error.localizedDescription;
  repeatVC.circleIcon = error.circleImage;
  repeatVC.circleBackground = [[UIImage imageNamed:@"circle_bg"] omn_tintWithColor:[OMNStyler redColor]];
  repeatVC.faded = YES;
  @weakify(self)
  repeatVC.didCloseBlock = ^{
    
    @strongify(self)
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
  };
  repeatVC.buttonInfo =
  @[
    [OMNBarButtonInfo infoWithTitle:kOMN_TRY_AGAIN_BUTTON_TITLE image:[UIImage imageNamed:@"repeat_icon_small"] block:^{
      
      @strongify(self)
      [self.navigationController omn_popToViewController:self animated:YES completion:^{
        
        [self loadWish];
        
      }];
      
    }]
    ];
  [self.navigationController pushViewController:repeatVC animated:YES];

}

- (void)show:(UIViewController *)presentingVC {
  
  self.navigationItem.titleView = [UIButton omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_black"] color:[UIColor blackColor] actionBlock:^{
    
    [presentingVC dismissViewControllerAnimated:YES completion:nil];
    
  }];
  [presentingVC presentViewController:[OMNNavigationController controllerWithRootVC:self] animated:YES completion:nil];
  
}

- (void)didLoadWish:(OMNWish *)wish {
  
  NSArray *wishItems = [wish.items bk_map:^id(OMNOrderItem *item) {
    
    return [[OMNWishCellItem alloc] initWithOrderItem:item];
    
  }];
  
  OMNWishStatusCellItem *item = [[OMNWishStatusCellItem alloc] init];
  item.wish = wish;
  
  _items =
  @[
    @[item],
    wishItems,
    ];
  [self.tableView reloadData];
  self.tableView.contentInset = UIEdgeInsetsMake(-CGRectGetHeight(self.tableView.tableHeaderView.frame), 0.0f, 50.0f, 0.0f);

}

- (void)omn_setup {
  
  [OMNWishCellItem registerCellForTableView:self.tableView];
  [OMNWishStatusCellItem registerCellForTableView:self.tableView];
  
  self.navigationController.navigationBar.translucent = NO;
  self.automaticallyAdjustsScrollViewInsets = NO;
  UIImageView *chequeImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
  self.tableView.tableFooterView = chequeImageView;
  self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wood_bg"]];
  
  UIView *headerView = [[UIView alloc] initWithFrame:self.view.bounds];
  headerView.backgroundColor = [UIColor whiteColor];
  self.tableView.tableHeaderView = headerView;
  self.tableView.contentInset = UIEdgeInsetsMake(-CGRectGetHeight(headerView.frame)/2.0f, 0.0f, 50.0f, 0.0f);
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.allowsSelection = NO;
  
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath {
  return _items[indexPath.section][indexPath.row];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return _items.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  NSArray *rowItems = _items[section];
  return [rowItems count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  return [item cellForTableView:tableView];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  id item = [self itemAtIndexPath:indexPath];
  return [item heightForTableView:tableView];
  
}

@end
