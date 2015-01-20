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

@implementation OMNPreorderActionCell {
  
  UIButton *_clearButton;
  UIButton *_actionButton;
  UILabel *_refreshLabel;
  UIButton *_refreshButton;
  
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

- (void)orderTap {
  
  if (self.didOrderBlock) {
    
    self.didOrderBlock();
    
  }
  
}

- (void)omn_setup {
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  
  _clearButton = [UIButton omn_autolayoutView];
  _clearButton.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
  [_clearButton setTitleColor:[colorWithHexString(@"000000") colorWithAlphaComponent:0.4f] forState:UIControlStateNormal];
  _clearButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
  [_clearButton setBackgroundImage:[[UIImage imageNamed:@"button_clear_wish"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
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
  [_refreshButton omn_setImage:[UIImage imageNamed:@"refresh_icon"] withColor:[UIColor blackColor]];
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
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:refreshView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[refreshLabel]|" options:kNilOptions metrics:metrics views:views]];
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[refreshButton]|" options:kNilOptions metrics:metrics views:views]];
  [refreshView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[refreshLabel]-(20)-[refreshButton]|" options:kNilOptions metrics:metrics views:views]];
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[clearButton]-(>=0)-[actionButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[clearButton]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(leftOffset)-[actionButton]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[refreshView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];

  [_clearButton setTitle:NSLocalizedString(@"PREORDER_CLEAR_BUTTON_TITLE", @"Очистить") forState:UIControlStateNormal];
  [_actionButton setTitle:NSLocalizedString(@"PREORDER_ORDER_BUTTON_TITLE", @"Заказать") forState:UIControlStateNormal];
  _refreshLabel.text = NSLocalizedString(@"PREORDER_REFRESH_LABEL_TITLE", @"Блюда на вашем столе");
  
}
@end
