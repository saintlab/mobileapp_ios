//
//  OMNPreorderActionCell.m
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderActionCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIButton+omn_helper.h"
#import "UIImage+omn_helper.h"
#import <BlocksKit.h>

@implementation OMNPreorderActionCell {
  NSString *_enabledObserverID;
}

- (void)dealloc {
  [self removeEnabledObserverID];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)removeEnabledObserverID {
  if (_enabledObserverID) {
    [_item bk_removeObserversWithIdentifier:_enabledObserverID];
  }
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)orderTap {
  
  [_item.delegate preorderActionCellDidOrder:self];
  
}

- (void)clearTap {
  
  [_item.delegate preorderActionCellDidClear:self];
  
}

- (void)refreshTap {
  
  [_item.delegate preorderActionCellDidRefresh:self];
  
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  UIColor *highlitedColor = [UIColor colorWithWhite:0.0f alpha:0.2f];
  _clearButton = [UIButton omn_autolayoutView];
  _clearButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_clearButton setTitleColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.4f] forState:UIControlStateNormal];
  [_clearButton setTitleColor:highlitedColor forState:UIControlStateHighlighted];
  _clearButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_clearButton addTarget:self action:@selector(clearTap) forControlEvents:UIControlEventTouchUpInside];
  
  UIImage *image = [[UIImage imageNamed:@"button_clear_wish"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
  [_clearButton setBackgroundImage:image forState:UIControlStateNormal];
  [_clearButton setBackgroundImage:[[[UIImage imageNamed:@"button_clear_wish"] omn_tintWithColor:highlitedColor] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateHighlighted];
  [self.contentView addSubview:_clearButton];
  
  _actionButton = [UIButton omn_autolayoutView];
  [_actionButton addTarget:self action:@selector(orderTap) forControlEvents:UIControlEventTouchUpInside];
  _actionButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_actionButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  _actionButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_actionButton setBackgroundImage:[[UIImage imageNamed:@"button_order"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [self.contentView addSubview:_actionButton];
  
  UIView *refreshView = [UIView omn_autolayoutView];
  [self.contentView addSubview:refreshView];
  
  _refreshLabel = [UILabel omn_autolayoutView];
  _refreshLabel.textColor = colorWithHexString(@"000000");
  _refreshLabel.font = FuturaLSFOmnomLERegular(22.0f);
  [refreshView addSubview:_refreshLabel];
  
  _refreshButton = [UIButton omn_autolayoutView];
  [_refreshButton addTarget:self action:@selector(refreshTap) forControlEvents:UIControlEventTouchUpInside];
  [_refreshButton omn_setImage:[UIImage imageNamed:@"refresh_icon"] withColor:[UIColor colorWithWhite:0.0f alpha:0.6f]];
  [refreshView addSubview:_refreshButton];
  
  NSDictionary *views =
  @{
    @"clearButton" : _clearButton,
    @"actionButton" : _actionButton,
    @"refreshLabel" : _refreshLabel,
    @"refreshButton" : _refreshButton,
    @"refreshView" : refreshView,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[refreshLabel]|" options:kNilOptions metrics:metrics views:views]];
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[refreshButton]|" options:kNilOptions metrics:metrics views:views]];
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[refreshLabel]-(>=0)-[refreshButton]" options:kNilOptions metrics:metrics views:views]];
  [refreshView addConstraint:[NSLayoutConstraint constraintWithItem:_refreshButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:refreshView attribute:NSLayoutAttributeRight multiplier:1.0f constant:-30.0f]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[refreshView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[clearButton]-(>=0)-[actionButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[clearButton]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[actionButton]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[refreshView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

  [_clearButton setTitle:NSLocalizedString(@"PREORDER_CLEAR_BUTTON_TITLE", @"Очистить") forState:UIControlStateNormal];
  [_actionButton setTitle:NSLocalizedString(@"PREORDER_ORDER_BUTTON_TITLE", @"Заказать") forState:UIControlStateNormal];
  _refreshLabel.text = NSLocalizedString(@"PREORDER_REFRESH_LABEL_TITLE", @"Блюда на вашем столе");
  
}

- (void)setItem:(OMNPreorderActionCellItem *)item {
  
  [self removeEnabledObserverID];
  _item = item;
  @weakify(self)
  [_item bk_addObserverForKeyPath:NSStringFromSelector(@selector(enabled)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateEnabledState];
    
  }];
  _refreshLabel.text = item.actionText;
  
}

- (void)updateEnabledState {
  
  _clearButton.enabled = _item.enabled;
  _actionButton.enabled = _item.enabled;
  
}

@end
