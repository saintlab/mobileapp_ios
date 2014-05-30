//
//  GViewController.m
//  beacon
//
//  Created by tea on 19.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GViewController.h"
#import "OMNBeaconBackgroundManager.h"
#import "GBeaconForegroundManager.h"
#import "OMNBeacon.h"
#import "GTableVC.h"
#import "OMNBeaconSearchManager.h"
#import "OMNBeaconRangingManager.h"

@interface GViewController ()
<GTableVCDelegate> {
  OMNBeaconRangingManager *_beaconRangingManager;
  BOOL _tableShown;
  
}

@property (nonatomic, strong) NSArray *beacons;

@end

@implementation GViewController

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  __weak typeof(self)weakSelf = self;
  _beaconRangingManager = [[OMNBeaconRangingManager alloc] initWithAuthorizationStatus:^(CLAuthorizationStatus status) {
    
    if (kCLAuthorizationStatusDenied == status) {
      
      [weakSelf didFailRangeBeacons];
      
    }
    
  }];
  
  
  [_beaconRangingManager rangeNearestBeacons:^(NSArray *beacons) {
    
//    [weakSelf didRangeBeacons:beacons];
    
  } failure:^{
    
    [weakSelf didFailRangeBeacons];
    
  }];
  
//  [[GBeaconForegroundManager manager] startMonitoring];
  
//  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beaconsDidChange:) name:OMNBeaconsManagerDidChangeBeaconsNotification object:nil];
  
//  UILabel *label = [[UILabel alloc] init];
//  label.text = @"searching for beacons...";
//  [label sizeToFit];
//  label.center = self.view.center;
//  [self.view addSubview:label];
  
}

- (void)didFailRangeBeacons {
  
  [_beaconRangingManager stop];
  _beaconRangingManager = nil;
  
}

- (void)beaconsDidChange:(NSNotification *)n {
  
  if (_tableShown) {
    return;
  }

  OMNBeaconsManager *beaconManager = n.object;
  
  NSArray *beacons = beaconManager.atTheTableBeacons;
  
  [self updateWithBeacons:beacons];
  
  if (beacons.count) {
    
//    __weak typeof(self)weakSelf = self;

//    [OMNBeacon dec]
    
//    [OMNBeacon decodeBeacons:beacons success:^(NSArray *decodedBeacons) {
//      
//      [weakSelf updateWithBeacons:decodedBeacons];
//      
//    } failure:^(NSError *error) {
//      
//      NSLog(@"%@", error);
//      
//    }];
    
  }
  else {
    
    [self updateWithBeacons:nil];
    
  }
  
}

- (void)updateWithBeacons:(NSArray *)beacons {
  
  self.beacons = beacons;
  [self.tableView reloadData];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  
}

- (void)search {
  
//  [GOrder ordersWithBlock:^(NSArray *orders, NSError *error) {
//    
//  }];
  
}

#pragma mark - GTableVCDelegate

- (void)tableVCDidFinish:(GTableVC *)tableVC {
  
  [self dismissViewControllerAnimated:YES completion:^{
    _tableShown = NO;
  }];
  
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.beacons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"CellIdentifier";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (nil == cell) {
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  
  [self configureCell:cell forRowAtIndexPath:indexPath];
  
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNBeacon *beacon = self.beacons[indexPath.row];
  cell.textLabel.text = beacon.UUIDString;
//  cell.textLabel.text = beacon.restaurantId;
//  cell.detailTextLabel.text = beacon.tableId;
  
}

@end
