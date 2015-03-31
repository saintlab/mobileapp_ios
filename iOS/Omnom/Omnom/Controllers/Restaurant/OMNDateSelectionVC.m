//
//  OMNDateSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDateSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"

@interface OMNDateSelectionVC ()
<UITableViewDelegate,
UITableViewDataSource>

@end

@implementation OMNDateSelectionVC {
  
  NSArray *_dates;
  UITableView *_tableView;
  
}

- (instancetype)initWithDates:(NSArray *)dates {
  self = [super init];
  if (self) {
    
    _dates = dates;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self omn_setup];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.navigationItem.title = kOMN_RESTAURANT_DATE_SELECTION_TITLE;
  self.navigationItem.leftBarButtonItem = [UIBarButtonItem omn_barButtonWithImage:[UIImage imageNamed:@"cross_icon_white"] color:[UIColor blackColor] target:self action:@selector(closeTap)];
  
}

- (void)closeTap {
  
  if (self.didCloseBlock) {
    self.didCloseBlock();
  }
  
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
  return _dates.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  NSString *date = _dates[indexPath.row];
  cell.textLabel.text = date;
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *date = _dates[indexPath.row];
  self.didSelectDateBlock(date);
  
}

@end
