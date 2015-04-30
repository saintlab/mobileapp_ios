//
//  OMNTipButton.m
//  restaurants
//
//  Created by tea on 02.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTipButton.h"
#import "OMNTip.h"
#import <OMNStyler.h>
#import <BlocksKit.h>

@implementation OMNTipButton {
  
  NSString *_selectedTipObserverID;
  
}

- (void)dealloc {

  [self removeObservers];
  
}

- (void)removeObservers {
  
  if (_selectedTipObserverID) {
    [_tip bk_removeObserversWithIdentifier:_selectedTipObserverID];
  }
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)awakeFromNib {
  
  [self setup];
  
}

- (void)setup {
  
  [self setTitleColor:[colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
  [self setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateSelected];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.font = FuturaLSFOmnomLERegular(17.0f);
  
}

- (void)setTip:(OMNTip *)tip {

  [self removeObservers];
  _tip = tip;
  @weakify(self)
  _selectedTipObserverID = [_tip bk_addObserverForKeyPath:NSStringFromSelector(@selector(selected)) options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial) task:^(OMNTip *t, NSDictionary *change) {
    
    @strongify(self)
    self.selected = t.selected;
    
  }];

}

- (void)setSelected:(BOOL)selected {
  
  CGFloat fontSize = (selected) ? (25.0f) : (17.0f);
  self.titleLabel.font = FuturaLSFOmnomLERegular(fontSize);
  [super setSelected:selected];
  
}

@end
