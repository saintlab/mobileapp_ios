//
//  OMNMenuProductWithRecommedtationsCell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductWithRecommedtationsCell.h"
#import <BlocksKit.h>

@interface OMNMenuProductWithRecommedtationsCell ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductWithRecommedtationsCell {
  
  UITableView *_tableView;
  NSString *_menuProductSelectionObserverID;
  
}

- (void)dealloc {
  [self removeObservers];
}

- (void)removeObservers {
  
  if (_menuProductSelectionObserverID) {
    [self.item bk_removeObserversWithIdentifier:_menuProductSelectionObserverID];
  }
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];

  }
  return self;
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  self.clipsToBounds = YES;
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.scrollEnabled = NO;
  [self.contentView addSubview:_tableView];

  [OMNMenuProductWithRecommendationsCellItem registerProductWithRecommendationsCellForTableView:_tableView];

  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    };
  
  NSDictionary *metrics = @{};

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self layoutIfNeeded];
  
}

- (void)setItem:(OMNMenuProductWithRecommendationsCellItem *)item {
  
  [self removeObservers];
  _item = item;
  _item.productItemDelegate = self;
  _tableView.delegate = _item;
  _tableView.dataSource = _item;
  [_tableView reloadData];
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCellDidEdit:(OMNMenuProductCell *)menuProductCell {
  [self.item.recommedtationItemDelegate menuProductWithRecommedtationsCell:self editCell:menuProductCell];  
}

- (void)menuProductCellDidSelect:(OMNMenuProductCell *)menuProductCell {
  [self.item.recommedtationItemDelegate menuProductWithRecommedtationsCell:self didSelectCell:menuProductCell];
}

@end
