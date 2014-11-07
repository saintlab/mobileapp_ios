//
//  OMNOrderTotalView.m
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderTotalView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUtils.h"
#import "OMNToolbarButton.h"
#import <BlocksKit+UIKit.h>

NSString * const OMNOrderTotalViewIdentifier = @"OMNOrderTotalViewIdentifier";

@implementation OMNOrderTotalView {
  
  OMNToolbarButton *_splitButton;
  OMNToolbarButton *_editButton;
  OMNToolbarButton *_cancelButton;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIColor *backgroundColor = [UIColor whiteColor];
  self.backgroundColor = backgroundColor;
  
  __weak typeof(self)weakSelf = self;
  
  _splitButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"divide_split_icon"] title:NSLocalizedString(@"SPLIT_ORDER_TITLE", @"Разделить счет") color:colorWithHexString(@"D0021B")];
  [_splitButton bk_addEventHandler:^(id sender) {
    
    [weakSelf.delegate orderTotalViewDidSplit:weakSelf];
    
  } forControlEvents:UIControlEventTouchUpInside];
  _splitButton.alpha = 0.0f;
  _splitButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_splitButton];
  
  _editButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"divide_split_icon"] title:NSLocalizedString(@"SPLIT_EDIT_TITLE", @"Изменить") color:colorWithHexString(@"D0021B")];
  [_editButton bk_addEventHandler:^(id sender) {
    
    [weakSelf.delegate orderTotalViewDidSplit:weakSelf];
    
  } forControlEvents:UIControlEventTouchUpInside];
  _editButton.alpha = 0.0f;
  _editButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_editButton];
  
  _cancelButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"cancel_split_icon"] title:NSLocalizedString(@"SPLIT_CANCEL_TITLE", @"Отменить") color:colorWithHexString(@"888888")];
  [_cancelButton bk_addEventHandler:^(id sender) {
    
    [weakSelf.delegate orderTotalViewDidCancel:weakSelf];
    
  } forControlEvents:UIControlEventTouchUpInside];
  _cancelButton.alpha = 0.0f;
  _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_cancelButton];
  
  NSDictionary *views =
  @{
    @"splitButton" : _splitButton,
    @"editButton" : _editButton,
    @"cancelButton" : _cancelButton,
    };
  
  NSDictionary *metrics =
  @{
    @"labelHeight" : @(24.0f),
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cancelButton]" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splitButton]|" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splitButton]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[editButton]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cancelButton]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  _order = order;
  
  BOOL hasSelectedItems = _order.hasSelectedItems;
  _splitButton.alpha = (hasSelectedItems) ? (0.0f) : (1.0f);
  _editButton.alpha = (hasSelectedItems) ? (1.0f) : (0.0f);
  _cancelButton.alpha = (hasSelectedItems) ? (1.0f) : (0.0f);
  
}

@end
