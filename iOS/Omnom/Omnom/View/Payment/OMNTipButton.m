//
//  OMNTipButton.m
//  restaurants
//
//  Created by tea on 02.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTipButton.h"
#import "OMNTip.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@implementation OMNTipButton

- (void)dealloc {
  @try {
    [_tip removeObserver:self forKeyPath:NSStringFromSelector(@selector(selected))];
  }
  @catch (NSException *exception) {
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
  
  [self setTitleColor:[colorWithHexString(@"ffffff") colorWithAlphaComponent:0.6] forState:UIControlStateNormal];
  [self setTitleColor:colorWithHexString(@"ffffff") forState:UIControlStateSelected];
  self.titleLabel.numberOfLines = 0;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.font = FuturaLSFOmnomLERegular(17.0f);
  
}

- (void)setTip:(OMNTip *)tip {

  [_tip removeObserver:self forKeyPath:NSStringFromSelector(@selector(selected))];
  _tip = tip;
  [_tip addObserver:self forKeyPath:NSStringFromSelector(@selector(selected)) options:NSKeyValueObservingOptionNew context:NULL];

}

- (void)setSelected:(BOOL)selected {
  
  if (selected) {
    self.titleLabel.font = FuturaLSFOmnomLERegular(25.0f);
  }
  else {
    self.titleLabel.font = FuturaLSFOmnomLERegular(17.0f);
  }
  
  [super setSelected:selected];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

  if ([keyPath isEqualToString:NSStringFromSelector(@selector(selected))]) {
    
    self.selected = _tip.selected;
    
  }

}

@end
