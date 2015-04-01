//
//  OMNRestaurantAddressModel.m
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressModel.h"
#import "OMNRestaurantAddressCellItem.h"
#import "OMNRestaurant+omn_network.h"
#import <BlocksKit.h>

@interface OMNRestaurantAddressModel ()

@property (nonatomic, strong) NSArray *addressesItems;

@end

@implementation OMNRestaurantAddressModel {
  
  
  OMNRestaurantAddressCellItem *_selectedItem;
  OMNRestaurant *_restaurant;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)registerTableView:(UITableView *)tableView {
  
  tableView.delegate = self;
  tableView.dataSource = self;
  [OMNRestaurantAddressCellItem registerCellForTableView:tableView];
  
}

- (void)loadAddressesWithCompletion:(dispatch_block_t)completionBlock {
  
  @weakify(self)
  [_restaurant getDeliveryAddressesWithCompletion:^(NSArray *addresses) {
    
    @strongify(self)
    self.addressesItems = [addresses bk_map:^id(OMNRestaurantAddress *address) {
      
      return [[OMNRestaurantAddressCellItem alloc] initWithRestaurantAddress:address];
      
    }];
    completionBlock();
    
  } failure:^(OMNError *error) {
    
    completionBlock();
    
  }];
  
}

- (OMNRestaurantAddress *)selectedAddress {
  return _selectedItem.address;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _addressesItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNRestaurantAddressCellItem *item = _addressesItems[indexPath.row];
  return [item cellForTableView:tableView];
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNRestaurantAddressCellItem *item = _addressesItems[indexPath.row];
  return [item heightForTableView:tableView];
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  _selectedItem.selected = NO;
  OMNRestaurantAddressCellItem *item = _addressesItems[indexPath.row];
  _selectedItem = item;
  _selectedItem.selected = YES;
  
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
  if (self.didSelectRestaurantAddressBlock) {
    
    self.didSelectRestaurantAddressBlock(item.address);
    
  }
  
}


@end
