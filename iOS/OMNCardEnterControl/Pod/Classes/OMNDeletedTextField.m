//
//  OMNDeletedTextField.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDeletedTextField.h"

@implementation OMNDeletedTextField

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self setup];
}

- (void)setError:(BOOL)error {
  _error = error;
  
  if (_error) {
    self.textColor = self.errorColor;
  }
  else {
    self.textColor = [UIColor whiteColor];
  }
  
  [self setNeedsDisplay];
}

- (void)setup {
  
  self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  self.errorColor = [UIColor colorWithRed:208.0f/255.0f green:2.0f/255.0f blue:27.0f/255.0f alpha:1.0f];
  [self addTarget:self action:@selector(editingDidChange) forControlEvents:UIControlEventEditingDidEnd];
  
}

- (void)editingDidChange {
  
  [self setNeedsDisplay];
  
}

- (void)deleteBackward {
  [super deleteBackward];
  if (0 == self.text.length) {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  UIColor *lineColor = nil;
  
  if (self.error) {

    lineColor = self.errorColor;
    
  }
  else {
    
    lineColor = (self.editing) ? ([UIColor whiteColor]) : ([UIColor colorWithWhite:1.0f alpha:0.3f]);
    
  }
  
  [lineColor set];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextFillRect(context, CGRectMake(0.0f, CGRectGetHeight(self.frame) - 1.0f, CGRectGetWidth(self.frame), 1.0f));

  
}

@end
