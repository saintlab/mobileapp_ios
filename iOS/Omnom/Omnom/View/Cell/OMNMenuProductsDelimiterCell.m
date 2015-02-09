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
  self.backgroundView.backgroundColor = [UIColor clearColor];
  self.backgroundColor = [UIColor clearColor];
  
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
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[line(1)]" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[line]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setMenuProductsDelimiter:(OMNMenuProductsDelimiter *)menuProductsDelimiter {
  
  [self removeMenuProductsDelimiterColorObserver];
  _menuProductsDelimiter = menuProductsDelimiter;
  __weak UIView *line = _line;
  _menuProductsDelimiterColorObserverID = [_menuProductsDelimiter bk_addObserverForKeyPath:NSStringFromSelector(@selector(color)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    line.backgroundColor = menuProductsDelimiter.color;
    
  }];
  
}

@end
