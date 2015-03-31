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
#import <OMNStyler.h>
#import <BlocksKit.h>
#import "UIImage+omn_helper.h"

@implementation OMNMenuCategoryHeaderView {
  
  OMNMenuHeaderLabel *_menuHeaderLabel;
  UIImageView *_iconView;
  NSString *_itemSelectedOberverId;
  UIButton *_button;
  BOOL _stuck;
  
}

- (void)dealloc {
  [self removeItemSelectedOberver];
}

- (void)removeItemSelectedOberver {
  if (_itemSelectedOberverId) {
    [_menuCategorySectionItem bk_removeObserversWithIdentifier:_itemSelectedOberverId];
  }
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
  
  _iconView = [UIImageView omn_autolayoutView];
  _iconView.alpha = 0.2f;
  [self addSubview:_iconView];
  
  NSDictionary *views =
  @{
    @"button" : _button,
    @"iconView" : _iconView,
    @"menuHeaderLabel" : _menuHeaderLabel,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:kNilOptions metrics:metrics views:views]];

  [self addConstraint:[NSLayoutConstraint constraintWithItem:_iconView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(3)-[iconView]" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[iconView(20)]" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  
  UIColor *bgColor = (selected) ? colorWithHexString(@"D3D3D3") : [UIColor clearColor];
  UIColor *textColor = (selected) ? colorWithHexString(@"484848") : [UIColor whiteColor];

  if (animated) {

    [UIView transitionWithView:_menuHeaderLabel duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
      
      _menuHeaderLabel.backgroundColor = bgColor;
      _menuHeaderLabel.textColor = textColor;
      
    } completion:nil];

  }
  else {
    
    _menuHeaderLabel.backgroundColor = bgColor;
    _menuHeaderLabel.textColor = textColor;

  }
  
}

- (void)buttonTap {
  
  [self.delegate menuCategoryHeaderViewDidSelect:self];
  
}

- (void)setMenuCategorySectionItem:(OMNMenuCategorySectionItem *)menuCategorySectionItem {
  
  [self removeItemSelectedOberver];
  _menuCategorySectionItem = menuCategorySectionItem;
  @weakify(self)
  [_menuCategorySectionItem bk_addObserverForKeyPath:NSStringFromSelector(@selector(entered)) options:(NSKeyValueObservingOptionNew) task:^(OMNMenuCategorySectionItem *obj, NSDictionary *change) {
    
    @strongify(self)
    [self setSelected:obj.entered animated:YES];
    
  }];
  [self setSelected:menuCategorySectionItem.entered animated:NO];
  _iconView.image = [[UIImage imageNamed:[NSString stringWithFormat:@"category_level%ld", menuCategorySectionItem.menuCategory.level + 1]] omn_tintWithColor:[UIColor blackColor]];
  self.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:(0.3f*menuCategorySectionItem.menuCategory.level)];
  _menuHeaderLabel.text = menuCategorySectionItem.menuCategory.name;
  
}

@end
