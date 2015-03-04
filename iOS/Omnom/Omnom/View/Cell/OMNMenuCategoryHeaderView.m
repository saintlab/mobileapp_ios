//
//  OMNMenuCategoryHeaderView.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryHeaderView.h"
#import "UIView+omn_autolayout.h"
#import "OMNMenuCategorySectionItem.h"
#import "OMNMenuHeaderLabel.h"

@implementation OMNMenuCategoryHeaderView {
  
  OMNMenuHeaderLabel *_menuHeaderLabel;
  UIButton *_button;
  
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:reuseIdentifier];
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
  
  self.backgroundView = [[UIView alloc] init];
  self.backgroundView.backgroundColor = [UIColor clearColor];
  self.clipsToBounds = YES;
  
  _button = [UIButton omn_autolayoutView];
  [_button addTarget:self action:@selector(buttonTap) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:_button];
  
  _menuHeaderLabel = [OMNMenuHeaderLabel omn_autolayoutView];
  [self addSubview:_menuHeaderLabel];
  
  NSDictionary *views =
  @{
    @"button" : _button,
    @"menuHeaderLabel" : _menuHeaderLabel,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(1@999)-[button]-(1@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)buttonTap {
  
  [self.delegate menuCategoryHeaderViewDidSelect:self];
  
}

- (void)setMenuCategorySectionItem:(OMNMenuCategorySectionItem *)menuCategorySectionItem {
  
  _menuCategorySectionItem = menuCategorySectionItem;
  _button.backgroundColor = [UIColor colorWithWhite:1.0f alpha:(0.3f*menuCategorySectionItem.menuCategory.level)];
  _menuHeaderLabel.text = menuCategorySectionItem.menuCategory.name;
  
}

@end
