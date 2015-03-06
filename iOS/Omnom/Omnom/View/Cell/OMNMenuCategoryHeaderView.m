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

@implementation OMNMenuCategoryHeaderView {
  
  OMNMenuHeaderLabel *_menuHeaderLabel;
  UIButton *_button;
  BOOL _stuck;
  
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
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:kNilOptions metrics:metrics views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[menuHeaderLabel]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  
  CGFloat top = [self convertPoint:CGPointZero toView:nil].y;

  [self setStuck:
   (
    top <= 64.0f &&
    _menuCategorySectionItem.selected
   )];
  
}

- (void)setStuck:(BOOL)stuck {
  
  if (stuck == _stuck) {
    return;
  }
  _stuck = stuck;
  
  UIColor *bgColor = (stuck) ? colorWithHexString(@"D3D3D3") : [UIColor clearColor];
  UIColor *textColor = (stuck) ? colorWithHexString(@"484848") : [UIColor whiteColor];

  [UIView transitionWithView:_button duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    _button.backgroundColor = bgColor;
    
  } completion:nil];
  [UIView transitionWithView:_menuHeaderLabel duration:0.35 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    _menuHeaderLabel.textColor = textColor;
    
  } completion:nil];
  
}

- (void)buttonTap {
  
  [self.delegate menuCategoryHeaderViewDidSelect:self];
  
}

- (void)setMenuCategorySectionItem:(OMNMenuCategorySectionItem *)menuCategorySectionItem {
  
  _menuCategorySectionItem = menuCategorySectionItem;
  self.backgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:(0.3f*menuCategorySectionItem.menuCategory.level)];
  _menuHeaderLabel.text = menuCategorySectionItem.menuCategory.name;
  
}

@end
