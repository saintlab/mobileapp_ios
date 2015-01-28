//
//  OMNMenuProductWithRecommedtationsCell.m
//  omnom
//
//  Created by tea on 27.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductWithRecommedtationsCell.h"
#import "OMNMenuProductCell.h"
#import <BlocksKit.h>

@interface OMNMenuProductWithRecommedtationsCell ()
<OMNMenuProductCellDelegate>

@end

@implementation OMNMenuProductWithRecommedtationsCell {
  
  UITableView *_tableView;
  OMNMenuProductWithRecommedtationsModel *_model;
  NSString *_menuProductSelectionObserverID;
  
}

- (void)dealloc {
  
  [self removeMenuProductSelectionObserver];
  
}

- (void)removeMenuProductSelectionObserver {
  
  if (_menuProductSelectionObserverID) {
    [_model bk_removeObserversWithIdentifier:_menuProductSelectionObserverID];
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
  
  _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  _tableView.translatesAutoresizingMaskIntoConstraints = NO;
  _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  _tableView.scrollEnabled = NO;
  [self.contentView addSubview:_tableView];

  [OMNMenuProductWithRecommedtationsModel registerCellsForTableView:_tableView];

  NSDictionary *views =
  @{
    @"tableView" : _tableView,
    };
  
  NSDictionary *metrics =
  @{
    };

  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:kNilOptions metrics:metrics views:views]];
  [self layoutIfNeeded];
  
}

- (void)setModel:(OMNMenuProductWithRecommedtationsModel *)model {
  
  [self removeMenuProductSelectionObserver];
  _model = model;
  _model.delegate = self;
  _tableView.delegate = model;
  _tableView.dataSource = model;
  [_tableView reloadData];
  
}

#pragma mark - OMNMenuProductCellDelegate

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell editProduct:(OMNMenuProduct *)menuProduct {
  
  [self.delegate menuProductWithRecommedtationsCell:self editMenuProduct:menuProduct];
  
}

- (void)menuProductCell:(OMNMenuProductCell *)menuProductCell didSelectProduct:(OMNMenuProduct *)menuProduct {
  
  [self.delegate menuProductWithRecommedtationsCell:self didSelectMenuProduct:menuProduct];
  
}

@end
