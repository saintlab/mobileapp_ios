//
//  OMNDateSelectionVC.m
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNDateSelectionVC.h"
#import "UIBarButtonItem+omn_custom.h"
#import "OMNConstants.h"
#import "NSString+omn_date.h"
#import <OMNStyler.h>

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
  _tableView.tableFooterView = [UIView new];
  _tableView.delegate = self;
  _tableView.dataSource = self;
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.rowHeight = 44.0f;
  [self.view addSubview:_tableView];
  
  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSDictionary *metrics =
  @{};
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.view layoutIfNeeded];
  
  UILabel *headerLabel = [[UILabel alloc] init];
  headerLabel.numberOfLines = 0;
  headerLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  headerLabel.font = FuturaOSFOmnomRegular(20.0f);
  headerLabel.text = kOMN_RESTAURANT_DATE_HEADER_TEXT;
  CGFloat offset = [OMNStyler styler].leftOffset.floatValue;
  CGFloat headerLabelHeight = [headerLabel sizeThatFits:CGSizeMake(CGRectGetWidth(_tableView.frame) - 2*offset, 9999.0f)].height;
  headerLabel.frame = CGRectMake(offset, offset, CGRectGetWidth(_tableView.frame) - 2*offset, headerLabelHeight);
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tableView.frame), headerLabelHeight + 2*offset)];
  [headerView addSubview:headerLabel];
  _tableView.tableHeaderView = headerView;
  
}

- (NSString *)dateStringFromDate:(NSString *)dateString {
  
  NSString *displayDateString = [dateString omn_localizedWeekday];
  if ([dateString omn_isTomorrow]) {
    displayDateString = [NSString stringWithFormat:kOMN_WEEKDAY_TOMORROW_FORMAT, displayDateString];
  }
 
  return displayDateString;
  
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
  cell.textLabel.font = FuturaOSFOmnomRegular(20.0f);
  cell.textLabel.textColor = [UIColor blackColor];
  NSString *date = _dates[indexPath.row];
  cell.textLabel.text = [self dateStringFromDate:date];
  return cell;
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSString *date = _dates[indexPath.row];
  self.didSelectDateBlock(date);
  
}

@end
