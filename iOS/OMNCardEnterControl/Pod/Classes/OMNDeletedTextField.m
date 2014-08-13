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

- (void)setup {
  self.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
}

- (void)deleteBackward {
  if (0 == self.text.length) {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  UIImage *image = [UIImage imageNamed:(self.editing) ? (@"input_card_number_field_active") : (@"input_card_number_field_no_active")];
  [image drawInRect:CGRectMake(0.0f, CGRectGetHeight(self.frame) - image.size.height, CGRectGetWidth(self.frame), image.size.height)];
  
}

@end
