//
//  OMNOrderCell.m
//  restaurants
//
//  Created by tea on 29.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItemCell.h"
#import "UIView+frame.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import <BlocksKit.h>

@implementation OMNOrderItemCell {
  UILabel *_nameLabel;
  UILabel *_priceLabel;
  
  UIImageView *_iconView;
  OMNOrderItem *_orderItem;
  NSString *_cellOrderItemIdentifier;
}

- (void)dealloc {
  
  [self removeOrderObserver];
  
}

- (void)removeOrderObserver {
  
  if (_cellOrderItemIdentifier) {
    
    [_orderItem bk_removeObserversWithIdentifier:_cellOrderItemIdentifier];
    _cellOrderItemIdentifier = nil;
    
  }
  
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  
  self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (UILabel *)label {
  
  UILabel *label = [[UILabel alloc] init];
  label.opaque = YES;
  label.translatesAutoresizingMaskIntoConstraints = NO;
  label.highlightedTextColor = [UIColor whiteColor];
  return label;
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.contentView.opaque = YES;
  self.contentView.backgroundColor = backgroundColor;
  
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.layer.masksToBounds = YES;
  self.selectedBackgroundView.backgroundColor = ([UIColor colorWithRed:2/255. green:193/255. blue:100/255. alpha:1]);
  
  UIView *seporatorView = [[UIView alloc] init];
  seporatorView.translatesAutoresizingMaskIntoConstraints = NO;
  seporatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  [self.contentView addSubview:seporatorView];
  
  _nameLabel = [self label];
  _nameLabel.backgroundColor = backgroundColor;
  _nameLabel.font = FuturaLSFOmnomLERegular(18.0f);
  [_nameLabel setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisHorizontal];
  [self.contentView addSubview:_nameLabel];
  
  _priceLabel = [self label];
  _priceLabel.backgroundColor = backgroundColor;
  _priceLabel.font = FuturaLSFOmnomLERegular(17.0f);
  _priceLabel.textAlignment = NSTextAlignmentRight;
  [self.contentView addSubview:_priceLabel];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceLabel" : _priceLabel,
    @"seporatorView" : seporatorView,
    };
  
  NSDictionary *metrics =
  @{
    @"labelsOffset" : @(12.0f),
    @"lowPriority" : @(UILayoutPriorityDefaultLow),
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[nameLabel][seporatorView(1)]|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[priceLabel]-1-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(labelsOffset)-[priceLabel]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[seporatorView]-(leftOffset)-|" options:0 metrics:metrics views:views]];
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  [self removeOrderObserver];
  _orderItem = orderItem;
  __weak typeof(self)weakSelf = self;
  _cellOrderItemIdentifier = [_orderItem bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:NSKeyValueObservingOptionNew task:^(id obj, NSDictionary *change) {

    [weakSelf updateLabelsColor];
    
  }];
  
  _iconView.image = orderItem.icon;
  
  NSString *priceQuantityString = nil;
  NSString *priceString = [OMNUtils commaStringFromKop:orderItem.price_per_item];
  if (orderItem.quantity != 1.0) {
    
    priceQuantityString = [NSString stringWithFormat:@"%@ x %@", [OMNUtils unitStringFromDouble:orderItem.quantity], priceString];
    
  }
  else {
    
    priceQuantityString = priceString;
    
  }

  _nameLabel.text = orderItem.name;
  _priceLabel.text = priceQuantityString;
  [self updateLabelsColor];
  
}

- (void)updateLabelsColor {
  
  BOOL fadeLabels = (self.fadeNonSelectedItems && !_orderItem.selected);
  
  UIColor *nameColor = [colorWithHexString(@"000000") colorWithAlphaComponent:(fadeLabels) ? (0.2f) : (1.0f)];
  UIColor *priceColor = [colorWithHexString(@"000000") colorWithAlphaComponent:(fadeLabels) ? (0.2f) : (0.8f)];
  
  _nameLabel.textColor = nameColor;
  _priceLabel.textColor = priceColor;
  
}

@end
