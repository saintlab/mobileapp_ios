//
//  OMNTableOrdersVC.m
//  restaurants
//
//  Created by tea on 19.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTableOrdersVC.h"
#import "OMNBeaconRangingManager.h"
#import "OMNDecodeBeacon.h"
#import "CLBeacon+GBeaconAdditions.h"

@interface OMNTableOrdersVC ()

@end

@implementation OMNTableOrdersVC {
  OMNBeaconRangingManager *_beaconRangingManager;
  NSArray *_decodedBeacons;
  
  
  UIRefreshControl *_refresh;
}

- (void)dealloc {
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
}

- (id)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.automaticallyAdjustsScrollViewInsets = YES;
  
  _refresh = [[UIRefreshControl alloc] init];
  [_refresh addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
  self.refreshControl = _refresh;
  
    
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
    [weakSelf handleFoundBeacons:beacons];
    
  } failure:^(NSError *error) {
    
    NSLog(@"error>%@", error);
    
  } status:nil];

}

- (void)refreshData {
  
  
  
}

- (void)handleFoundBeacons:(NSArray *)beacons {
  
  if (0 == beacons.count) {
    return;
  }
  [_beaconRangingManager stop];
  
  NSMutableArray *omnBeacons = [NSMutableArray arrayWithCapacity:beacons.count];
  
  [beacons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
    OMNBeacon *omnBeacon = [obj omn_beacon];
    [omnBeacons addObject:omnBeacon];
    
  }];
  
  __weak typeof(self)weakSelf = self;
  [OMNDecodeBeacon decodeBeacons:omnBeacons success:^(NSArray *decodeBeacons) {
    
    [weakSelf handleDecodedBeacons:decodeBeacons];
    
  } failure:^(NSError *error) {
    
  }];
  
}

- (void)handleDecodedBeacons:(NSArray *)decodedBeacons {
  
  _decodedBeacons = decodedBeacons;
  [self.tableView reloadData];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _decodedBeacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (nil == cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
  }
  
  OMNDecodeBeacon *decodeBeacon = _decodedBeacons[indexPath.row];
  cell.textLabel.text = decodeBeacon.restaurantId;
  cell.detailTextLabel.text = decodeBeacon.tableId;
  
  return cell;
  
}

@end
