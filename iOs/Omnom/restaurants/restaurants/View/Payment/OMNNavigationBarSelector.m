//
//  GNavSelector.m
//  seocialtest
//
//  Created by tea on 21.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNNavigationBarSelector.h"
#import "UIView+frame.h"

const CGFloat kButtonWidth = 100.0f;

@implementation OMNNavigationBarSelector {
  UIView *_buttonsContainerView;

  NSArray *_titles;
  
  NSMutableArray *_buttons;
}

- (instancetype)initWithTitles:(NSArray *)titles {
  self = [super initWithFrame:CGRectMake(0, 0, 320.0f, 40.0f)];
  if (self) {
    _titles = titles;
    [self setup];
  }
  return self;
}

- (void)setup {
  
  UIImageView *iv = [[UIImageView alloc] initWithFrame:self.bounds];
  iv.image = [UIImage imageNamed:@"nav_constrol_shadow"];
  [self addSubview:iv];
  
  CGRect frame = self.bounds;
  frame.size.width = kButtonWidth * _titles.count;
  _buttonsContainerView = [[UIView alloc] initWithFrame:frame];
  [self addSubview:_buttonsContainerView];
  
  
  _buttons = [NSMutableArray arrayWithCapacity:_titles.count];
  
  [_titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(idx * kButtonWidth, 0, kButtonWidth, self.height)];
    button.tag = idx;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"selected_nav_button"] forState:UIControlStateSelected];
    [_buttonsContainerView addSubview:button];
    
    [_buttons addObject:button];
    
  }];
  
  self.selectedIndex = 0;
  
}

- (void)buttonTap:(UIButton *)button {
  
  if (button.tag != self.selectedIndex) {

    self.selectedIndex = button.tag;
    [self sendActionsForControlEvents:UIControlEventValueChanged];

  }
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
  
  [_buttons enumerateObjectsUsingBlock:^(UIButton *b, NSUInteger idx, BOOL *stop) {
    b.selected = NO;
    b.titleLabel.font = [UIFont systemFontOfSize:13.0f];
  }];
  
  _selectedIndex = selectedIndex;
  
  UIButton *button = _buttons[_selectedIndex];
  button.selected = YES;
  
  [UIView animateWithDuration:0.2 animations:^{

    button.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    _buttonsContainerView.transform = CGAffineTransformMakeTranslation(self.width * 0.5 - button.x, 0);
    
  }];
  
}

@end
