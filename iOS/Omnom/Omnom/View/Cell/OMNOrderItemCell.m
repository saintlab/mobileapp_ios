//
//  OMNOrderCell.m
//  restaurants
//
//  Created by tea on 29.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItemCell.h"
#import <OMNStyler.h>
#import "OMNUtils.h"
#import <BlocksKit.h>
#import "UIView+omn_autolayout.h"

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
  
  UILabel *label = [UILabel omn_autolayoutView];
  label.opaque = YES;
  label.highlightedTextColor = [UIColor whiteColor];
  return label;
  
}

- (void)setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  self.contentView.opaque = YES;
  self.contentView.backgroundColor = backgroundColor;
  
  self.selectionStyle = UITableViewCellSelectionStyleDefault;
  self.selectedBackgroundView = [[UIView alloc] init];
  self.selectedBackgroundView.backgroundColor = ([UIColor colorWithRed:2.0f/255.0f green:193.0f/255.0f blue:100.0f/255.0f alpha:1.0f]);
  
  UIView *selectedSeporatorView = [UIView omn_autolayoutView];
  selectedSeporatorView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
  [self.selectedBackgroundView addSubview:selectedSeporatorView];
  
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
  
  UIView *seporatorView = [UIView omn_autolayoutView];
  seporatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  [self.contentView addSubview:seporatorView];
  
  NSDictionary *views =
  @{
    @"nameLabel" : _nameLabel,
    @"priceLabel" : _priceLabel,
    @"seporatorView" : seporatorView,
    @"selectedSeporatorView" : selectedSeporatorView,
    };
  
  NSDictionary *metrics =
  @{
    @"labelsOffset" : @(12.0f),
    @"lowPriority" : @(UILayoutPriorityDefaultLow),
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_nameLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:1.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_priceLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:1.0f]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[nameLabel]-(labelsOffset)-[priceLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[seporatorView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seporatorView(1)]-(0.5)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.selectedBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[selectedSeporatorView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.selectedBackgroundView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[selectedSeporatorView(1)]-(0.5)-|" options:kNilOptions metrics:metrics views:views]];
 
  [self layoutIfNeeded];
  
}

- (void)setOrderItem:(OMNOrderItem *)orderItem {
  
  [self removeOrderObserver];
  _orderItem = orderItem;
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

  @weakify(self)
  _cellOrderItemIdentifier = [_orderItem bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateLabelsColor];
    
  }];

}

- (void)updateLabelsColor {
  
  BOOL fadeLabels = (self.fadeNonSelectedItems && !_orderItem.selected);
  
  UIColor *nameColor = [colorWithHexString(@"000000") colorWithAlphaComponent:(fadeLabels) ? (0.2f) : (1.0f)];
  UIColor *priceColor = [colorWithHexString(@"000000") colorWithAlphaComponent:(fadeLabels) ? (0.2f) : (0.8f)];
  
  _nameLabel.textColor = nameColor;
  _priceLabel.textColor = priceColor;
  
}

@end
