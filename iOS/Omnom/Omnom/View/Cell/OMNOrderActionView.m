//
//  OMNOrderTotalView.m
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderActionView.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNUtils.h"
#import "OMNToolbarButton.h"
#import <BlocksKit+UIKit.h>

@implementation OMNOrderActionView {
  
  OMNToolbarButton *_splitButton;
  OMNToolbarButton *_editButton;
  OMNToolbarButton *_cancelButton;
  NSString *_setOrderIdentifier;
  
}

- (void)removeSetOrderObserver {
  
  if (_setOrderIdentifier) {
    [_order bk_removeObserversWithIdentifier:_setOrderIdentifier];
    _setOrderIdentifier = nil;
  }
  
}

- (void)dealloc {
  
  [self removeSetOrderObserver];
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  UIImageView *endBillIV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"zub"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeTile]];
  endBillIV.translatesAutoresizingMaskIntoConstraints = NO;
  [endBillIV setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
  [self addSubview:endBillIV];
  
  UIColor *backgroundColor = [UIColor whiteColor];
  
  UIView *bgView = [[UIView alloc] init];
  bgView.backgroundColor = backgroundColor;
  bgView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:bgView];
  
  self.backgroundColor = [UIColor clearColor];
  
  
  
  _splitButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"divide_split_icon"] title:kOMN_SPLIT_ORDER_BUTTON_TITLE color:[OMNStyler redColor]];
  @weakify(self)
  [_splitButton bk_addEventHandler:^(id sender) {
    
    @strongify(self)
    [self.delegate orderTotalViewDidSplit:self];
    
  } forControlEvents:UIControlEventTouchUpInside];
  _splitButton.alpha = 0.0f;
  _splitButton.translatesAutoresizingMaskIntoConstraints = NO;
  [bgView addSubview:_splitButton];
  
  _editButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"divide_split_icon"] title:kOMN_SPLIT_EDIT_BUTTON_TITLE color:[OMNStyler redColor]];
  [_editButton bk_addEventHandler:^(id sender) {
    
    @strongify(self)
    [self.delegate orderTotalViewDidSplit:self];
    
  } forControlEvents:UIControlEventTouchUpInside];
  _editButton.alpha = 0.0f;
  _editButton.translatesAutoresizingMaskIntoConstraints = NO;
  [bgView addSubview:_editButton];
  
  _cancelButton = [[OMNToolbarButton alloc] initWithFitImage:[UIImage imageNamed:@"cancel_split_icon"] title:kOMN_SPLIT_CANCEL_BUTTON_TITLE color:colorWithHexString(@"888888")];
  [_cancelButton addTarget:self action:@selector(cancelTap) forControlEvents:UIControlEventTouchUpInside];
  _cancelButton.alpha = 0.0f;
  _cancelButton.translatesAutoresizingMaskIntoConstraints = NO;
  [bgView addSubview:_cancelButton];
  
  NSDictionary *views =
  @{
    @"bgView" : bgView,
    @"endBillIV" : endBillIV,
    @"splitButton" : _splitButton,
    @"editButton" : _editButton,
    @"cancelButton" : _cancelButton,
    };
  
  NSDictionary *metrics =
  @{
    @"labelHeight" : @(24.0f),
    @"viewHeight" : @(50.0f),
    @"leftOffset" : [[OMNStyler styler] leftOffset],
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[bgView]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[endBillIV]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[bgView(>=0@750)]-(-0.5)-[endBillIV]|" options:kNilOptions metrics:metrics views:views]];
  
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cancelButton]" options:kNilOptions metrics:metrics views:views]];
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[splitButton]|" options:kNilOptions metrics:metrics views:views]];
  
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[splitButton]|" options:kNilOptions metrics:metrics views:views]];
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[editButton]|" options:kNilOptions metrics:metrics views:views]];
  [bgView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cancelButton]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)cancelTap {
  
  [self.delegate orderTotalViewDidCancel:self];
  
}

- (void)setOrder:(OMNOrder *)order {

  [self removeSetOrderObserver];
  _order = order;
  @weakify(self)
  _setOrderIdentifier = [_order bk_addObserverForKeyPath:NSStringFromSelector(@selector(hasSelectedItems)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateButtons];
    
  }];
  
}

- (void)updateButtons {
  
  BOOL hasSelectedItems = _order.hasSelectedItems;
  [UIView transitionWithView:self duration:0.3 options:kNilOptions animations:^{
    
    _splitButton.alpha = (hasSelectedItems) ? (0.0f) : (1.0f);
    _editButton.alpha = (hasSelectedItems) ? (1.0f) : (0.0f);
    _cancelButton.alpha = (hasSelectedItems) ? (1.0f) : (0.0f);
    
  } completion:nil];
  
}

@end
