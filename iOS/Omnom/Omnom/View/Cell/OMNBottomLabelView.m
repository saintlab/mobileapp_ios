//
//  OMNBottomLabelView.m
//  omnom
//
//  Created by tea on 25.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBottomLabelView.h"
#import "OMNConstants.h"

@implementation OMNBottomLabelView

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [self setup];
}

- (void)setup {
  
  self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.9f];
  
  _label = [[UILabel alloc] init];
  _label.translatesAutoresizingMaskIntoConstraints = NO;
  _label.textColor = [UIColor blackColor];
  _label.font = FuturaOSFOmnomRegular(30.0f);
  [self addSubview:_label];
  
  NSDictionary *views =
  @{
    @"label" : _label,
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(50)]|" options:0 metrics:nil views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:views]];
  
}

@end
