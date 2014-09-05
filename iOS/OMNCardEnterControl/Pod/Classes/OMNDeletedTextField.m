//
//  OMNDeletedTextField.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDeletedTextField.h"
#import <OMNStyler.h>

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
    self.textColor = colorWithHexString(@"000000");
  }
  
  [self setNeedsDisplay];
}

- (void)setup {
  self.errorColor = colorWithHexString(@"d0021b");
  self.font = [UIFont fontWithName:@"Futura-LSF-Omnom-Regular" size:20.0f];
}

- (void)deleteBackward {
  if (0 == self.text.length) {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (self.error) {

    [self.errorColor set];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextFillRect(context, CGRectMake(0.0f, CGRectGetHeight(self.frame) - 1.0f, CGRectGetWidth(self.frame), 1.0f));
    
  }
  else {
    UIImage *image = [UIImage imageNamed:(self.editing) ? (@"input_card_number_field_active") : (@"input_card_number_field_no_active")];
    [image drawInRect:CGRectMake(0.0f, CGRectGetHeight(self.frame) - image.size.height, CGRectGetWidth(self.frame), image.size.height)];
  }
  
}

@end
