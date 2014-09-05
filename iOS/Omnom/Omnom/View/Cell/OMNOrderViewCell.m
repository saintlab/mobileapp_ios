//
//  OMNOrderItemCell.m
//  restaurants
//
//  Created by tea on 02.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderViewCell.h"
#import "OMNOrderDataSource.h"
#import "OMNOrderTableView.h"

@implementation OMNOrderViewCell {
  OMNOrderDataSource *_orderDataSource;
  UILabel *_label;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.frame), 50.0f)];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    _label.font = FuturaLSFOmnomRegular(24.0f);
    [self addSubview:_label];
    
    _orderDataSource = [[OMNOrderDataSource alloc] initWithOrder:nil];

    _orderDataSource.showTotalView = YES;
    
    CGRect tableFrame = CGRectMake(0.0f, CGRectGetHeight(_label.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetHeight(_label.frame));
    _tableView = [[OMNOrderTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.dataSource = _orderDataSource;
    _tableView.delegate = _orderDataSource;
    _tableView.userInteractionEnabled = NO;
    _tableView.allowsSelection = NO;
    [self addSubview:_tableView];
    
    [_orderDataSource registerCellsForTableView:self.tableView];

  }
  return self;
}

- (void)setIndex:(NSInteger)index {
  _index = index;
  _label.text = [NSString stringWithFormat:@"Счет %ld", (long)index + 1];
}

- (void)setHighlighted:(BOOL)highlighted {
  
}

- (void)setSelected:(BOOL)selected {
  
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  
  _orderDataSource.order = order;
  [_tableView reloadData];
  [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

@end
