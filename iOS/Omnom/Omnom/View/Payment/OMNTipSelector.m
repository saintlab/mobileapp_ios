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

@implementation OMNTipSelector {
  NSMutableArray *_buttons;
  UIView *_contentView;
}

- (void)dealloc {
  
  @try {
    [_order removeObserver:self forKeyPath:NSStringFromSelector(@selector(selectedTipIndex))];
  }
  @catch (NSException *exception) {}
  
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
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:metrics views:views]];
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_contentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[b1(buttonWidth)][seporatorView1][b2(buttonWidth)][seporatorView2][b3(buttonWidth)][seporatorView3][b4(buttonWidth)]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b1]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b2]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b3]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[b4]|" options:0 metrics:metrics views:views]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView2 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [_contentView addConstraint:[NSLayoutConstraint constraintWithItem:seporatorView3 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_contentView attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  
}

- (void)tipButtonTap:(OMNTipButton *)tipButton {
  
  self.selectedIndex = tipButton.tag;
  if (kCustomTipIndex == self.selectedIndex) {
    
    [self.delegate tipSelectorStartCustomTipEditing:self];
    
  }
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {

  _previousSelectedIndex = self.selectedIndex;
  _order.selectedTipIndex = selectedIndex;
  
}

- (NSInteger)selectedIndex {
  
  return _order.selectedTipIndex;
  
}

- (void)update {
  
  OMNOrder *order = _order;
  [_buttons enumerateObjectsUsingBlock:^(OMNTipButton *tipButton, NSUInteger idx, BOOL *stop) {
    
    tipButton.tip = order.tips[idx];
    [order configureTipButton:tipButton];
    
  }];
  
}

- (void)setOrder:(OMNOrder *)order {
  
  NSString *keyPath = NSStringFromSelector(@selector(selectedTipIndex));
  [_order removeObserver:self forKeyPath:keyPath];
  _order = order;
  [_order addObserver:self forKeyPath:keyPath options:(NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew) context:NULL];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  
  if ([object isEqual:_order] &&
      [keyPath isEqualToString:NSStringFromSelector(@selector(selectedTipIndex))]) {
    
    [self update];
    
  }
  else {
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    
  }
  
}

@end
