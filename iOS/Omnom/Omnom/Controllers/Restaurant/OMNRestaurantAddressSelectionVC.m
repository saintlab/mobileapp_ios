//
//  OMNRestaurantAddressSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantAddressSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNRestaurant+omn_network.h"

@interface OMNRestaurantAddressSelectionVC ()
<UITableViewDataSource,
UITableViewDelegate>

@property (nonatomic, strong) NSArray *addresses;

@end

@implementation OMNRestaurantAddressSelectionVC {
  
  OMNRestaurant *_restaurant;
  UITableView *_tableView;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = kOMN_RESTAURANT_ADDRESS_SELECTION_TITLE;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];

  @weakify(self)
  [_restaurant getDeliveryAddressesWithCompletion:^(NSArray *addresses) {
    
    @strongify(self)
    [self didLoadAddresses:addresses];
    
  } failure:^(OMNError *error) {
    
  }];
  
}

- (void)didLoadAddresses:(NSArray *)addresses {
  
  self.addresses = addresses;
  [_tableView reloadData];
  
}

- (void)closeTap {
  
  self.didCloseBlock();
  
}

- (void)omn_setup {
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:_tableView];
  
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return _addresses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  OMNRestaurantAddress *address = _addresses[indexPath.row];
  cell.textLabel.text = address.text;
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  OMNRestaurantAddress *address = _addresses[indexPath.row];
  self.didSelectRestaurantAddressBlock(address);
  
}

@end
