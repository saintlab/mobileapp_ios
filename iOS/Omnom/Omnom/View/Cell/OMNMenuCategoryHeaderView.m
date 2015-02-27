//
//  OMNMenuCategoryHeaderView.m
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuCategoryHeaderView.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNMenuCategorySectionItem.h"

@implementation OMNMenuCategoryHeaderView {
  
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
  [_button setTitleColor:colorWithHexString(@"7B7B7B") forState:UIControlStateNormal];
  _button.titleLabel.textAlignment = NSTextAlignmentCenter;
  _button.backgroundColor = [OMNStyler toolbarColor];
  _button.titleLabel.font = FuturaLSFOmnomLERegular(17.0f);
  [self addSubview:_button];
  
  NSDictionary *views =
  @{
    @"button" : _button,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(1@999)-[button]-(1@999)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(2@999)-[button]-(2@999)-|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)buttonTap {
  
  [self.delegate menuCategoryHeaderViewDidSelect:self];
  
}

- (void)setMenuCategorySectionItem:(OMNMenuCategorySectionItem *)menuCategorySectionItem {
  
  _menuCategorySectionItem = menuCategorySectionItem;
  _button.titleLabel.font = FuturaLSFOmnomLERegular((0 == menuCategorySectionItem.menuCategory.level) ? (17.0f) : (13.0f));
  [_button setTitle:menuCategorySectionItem.menuCategory.name forState:UIControlStateNormal];
  
}

@end
