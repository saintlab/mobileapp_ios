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
#import "OMNOrderTotalView.h"
#import <OMNStyler.h>

@implementation OMNOrderViewCell {
  OMNOrderDataSource *_orderDataSource;
  OMNOrderTotalView *_orderTotalView;
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
    _label.font = FuturaOSFOmnomMedium(20.0f);
    [self addSubview:_label];
    
    _orderDataSource = [[OMNOrderDataSource alloc] init];

    CGFloat tableWidth = CGRectGetWidth([UIScreen mainScreen].bounds);
    CGFloat scale = CGRectGetWidth(self.frame)/tableWidth;
    CGFloat tableHeight = (CGRectGetHeight(self.frame) - CGRectGetHeight(_label.frame))/scale;
    
    CGRect tableFrame = CGRectMake(0.0f,0.0f, tableWidth, tableHeight);
    _tableView = [[OMNOrderTableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    _tableView.dataSource = _orderDataSource;
    _tableView.delegate = _orderDataSource;
    _tableView.userInteractionEnabled = NO;
    _tableView.allowsSelection = NO;
    [self addSubview:_tableView];
    
    _orderTotalView = [[OMNOrderTotalView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(_tableView.frame), OMNStyler.orderTableFooterHeight)];
    _tableView.tableFooterView = _orderTotalView;
    _tableView.layer.anchorPoint = CGPointMake(0.0f, 0.0f);
    _tableView.transform = CGAffineTransformMakeScale(scale, scale);
    
    [OMNOrderDataSource registerCellsForTableView:_tableView];
  }
  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];
  _tableView.center = CGPointMake(0.0f, CGRectGetMaxY(_label.frame));
}

- (void)setIndex:(NSInteger)index {
  
  _index = index;
  _label.text = [NSString stringWithFormat:kOMN_ORDER_NUMBER_FORMAT, (long)index + 1];
  
}

- (void)setHighlighted:(BOOL)highlighted {
}

- (void)setSelected:(BOOL)selected {
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  
  _orderDataSource.order = order;
  [_tableView reloadData];
  
  OMNGuest *guest = [_order.guests lastObject];
  
  if (_order.guests.count > 0 &&
      guest.items.count > 0) {
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:guest.items.count - 1 inSection:_order.guests.count - 1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    _tableView.layer.rasterizationScale = 2.0f;
    _tableView.layer.shouldRasterize = YES;
    
  }
  
  _orderTotalView.order = order;

}

@end
