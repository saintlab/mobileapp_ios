//
//  GTipSelector.m
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTipSelector.h"
#import "OMNTipButton.h"
#import "OMNOrder+tipButton.h"
#import <BlocksKit.h>

@implementation OMNTipSelector {
  
  NSMutableArray *_buttons;
  UIView *_contentView;
  NSString *_selectedTipIndexObserverIdentifier;
  
}


- (void)dealloc {
  
  [self removeSelectedTipIndexObserver];
  
}

- (void)removeSelectedTipIndexObserver {
  
  if (_selectedTipIndexObserverIdentifier) {
    [_order bk_removeObserversWithIdentifier:_selectedTipIndexObserverIdentifier];
  }
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)setup {
  
  _previousSelectedIndex = -1;
  [self setupButtons];
  self.backgroundColor = [UIColor clearColor];
  
  UISwipeGestureRecognizer *swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.delaysTouchesBegan = YES;
  swipeGR.direction = UISwipeGestureRecognizerDirectionRight;
  [self addGestureRecognizer:swipeGR];
  
  swipeGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
  swipeGR.delaysTouchesBegan = YES;
  swipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
  [self addGestureRecognizer:swipeGR];
  
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeGR {
  
  switch (swipeGR.direction) {
    case UISwipeGestureRecognizerDirectionRight: {
      
      self.selectedIndex = MIN(self.selectedIndex + 1, kCustomTipIndex);
      
    } break;
    case UISwipeGestureRecognizerDirectionLeft: {
      
      self.selectedIndex = MAX(self.selectedIndex - 1, 0);
      
    } break;
    case UISwipeGestureRecognizerDirectionUp:
    case UISwipeGestureRecognizerDirectionDown:
    default: {
    } break;
  }
  
}

- (OMNTipButton *)tipButtonWithTag:(NSInteger)tag {
  
  OMNTipButton *tipButton = [[OMNTipButton alloc] init];
  tipButton.translatesAutoresizingMaskIntoConstraints = NO;
  tipButton.tag = tag;
  [tipButton addTarget:self action:@selector(tipButtonTap:) forControlEvents:
   UIControlEventTouchUpInside];
  [_contentView addSubview:tipButton];
  [_buttons addObject:tipButton];
  return tipButton;
  
}

- (UIImageView *)seporatorView {
  
  UIImageView *seporatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bill_tips_divider"]];
  seporatorView.translatesAutoresizingMaskIntoConstraints = NO;
  [_contentView addSubview:seporatorView];
  return seporatorView;
  
}

- (void)setupButtons {
  
  _buttons = [NSMutableArray arrayWithCapacity:4];
  
  _contentView = [[UIView alloc] init];
  _contentView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_contentView];
  
  OMNTipButton *b1 = [self tipButtonWithTag:0];
  OMNTipButton *b2 = [self tipButtonWithTag:1];
  OMNTipButton *b3 = [self tipButtonWithTag:2];
  OMNTipButton *b4 = [self tipButtonWithTag:3];

  UIImageView *seporatorView1 = [self seporatorView];
  UIImageView *seporatorView2 = [self seporatorView];
  UIImageView *seporatorView3 = [self seporatorView];
  
  NSDictionary *views =
  @{
    @"b1" : b1,
    @"b2" : b2,
    @"b3" : b3,
    @"b4" : b4,
    @"seporatorView1" : seporatorView1,
    @"seporatorView2" : seporatorView2,
    @"seporatorView3" : seporatorView3,
    @"contentView" : _contentView,
    };

  NSDictionary *metrics =
  @{
    @"buttonWidth" : @(76.0f)
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b1(buttonWidth)][seporatorView1][b2(buttonWidth)][seporatorView2][b3(buttonWidth)][seporatorView3][b4(buttonWidth)]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b1]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b2]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b3]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b4]|" options:kNilOptions metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

- (void)tipButtonTap:(OMNTipButton *)tipButton {

  self.selectedIndex = tipButton.tag;
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

  _previousSelectedIndex = self.selectedIndex;
  _order.selectedTipIndex = selectedIndex;
  if (kCustomTipIndex == selectedIndex) {
    
    [self.delegate tipSelectorStartCustomTipEditing:self];
    
  }
  
}

- (NSInteger)selectedIndex {
  
  return _order.selectedTipIndex;
  
}

- (void)updateButtons {
  
  OMNOrder *order = _order;
  [_buttons enumerateObjectsUsingBlock:^(OMNTipButton *tipButton, NSUInteger idx, BOOL *stop) {
    
    tipButton.tip = order.tips[idx];
    [order configureTipButton:tipButton];
    
  }];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  [self removeSelectedTipIndexObserver];
  _order = order;
  _previousSelectedIndex = _order.selectedTipIndex;
  @weakify(self)
  _selectedTipIndexObserverIdentifier = [_order bk_addObserverForKeyPath:NSStringFromSelector(@selector(selectedTipIndex)) options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) task:^(id obj, NSDictionary *change) {
    
    @strongify(self)
    [self updateButtons];
    
  }];
  
}

@end
