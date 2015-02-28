//
//  OMNMenuProductsDelimiterCell.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductsDelimiterCell.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import <BlocksKit.h>

@implementation OMNMenuProductsDelimiterCell {
  
  UIView *_line;
  NSString *_menuProductsDelimiterColorObserverID;
  NSLayoutConstraint *_lineHeightConstraint;
  
}

- (void)dealloc {
  
  [self removeMenuProductsDelimiterColorObserver];
  
}

- (void)removeMenuProductsDelimiterColorObserver {
  
  if (_menuProductsDelimiterColorObserverID) {
    [_menuProductsDelimiter bk_removeObserversWithIdentifier:_menuProductsDelimiterColorObserverID];
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
  self.backgroundView = [[UIView alloc] init];
  
  self.backgroundView.backgroundColor = [UIColor whiteColor];
  self.backgroundColor = [UIColor whiteColor];
  
  _line = [UIView omn_autolayoutView];
  [self.contentView addSubview:_line];

  NSDictionary *views =
  @{
    @"line" : _line,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[line]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[line]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
  _lineHeightConstraint = [NSLayoutConstraint constraintWithItem:_line attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0f constant:1.0f];
  [self.contentView addConstraint:_lineHeightConstraint];
  
}

- (void)updateLineView {
  
  CGFloat height = 1.0f;
  UIColor *backgroundColor = nil;
  
  if (_menuProductsDelimiter.selected) {
    
    backgroundColor = colorWithHexString(@"F5A623");
    height = 2.0f;

  }
  else {
    
    switch (_menuProductsDelimiter.type) {
      case kMenuProductsDelimiterTypeNone: {
        
        backgroundColor = [UIColor clearColor];
        
      } break;
      case kMenuProductsDelimiterTypeGray: {
        
        backgroundColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.2f];
        
      } break;
    }
    
  }
  
  _line.backgroundColor = backgroundColor;
  _lineHeightConstraint.constant = height;
  
}

- (void)setMenuProductsDelimiter:(OMNMenuProductsDelimiterCellItem *)menuProductsDelimiter {
  
  [self removeMenuProductsDelimiterColorObserver];
  _menuProductsDelimiter = menuProductsDelimiter;
  __weak typeof(self)weakSelf = self;
  _menuProductsDelimiterColorObserverID = [_menuProductsDelimiter bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    [weakSelf updateLineView];
    
  }];
  
}

@end
