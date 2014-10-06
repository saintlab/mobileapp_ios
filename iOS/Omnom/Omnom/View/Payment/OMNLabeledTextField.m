//
//  OMNLabeledTextField.m
//  omnom
//
//  Created by tea on 26.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLabeledTextField.h"
#import "OMNUtils.h"

@interface OMNLabeledTextField ()

@end

@implementation OMNLabeledTextField 

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
  _detailedText = @"";
}

- (void)setDetailedText:(NSString *)text {
  if (text) {
    _detailedText = text;
    self.text = self.text;
  }
}

- (BOOL)becomeFirstResponder {
  BOOL become = [super becomeFirstResponder];
  [self updateSelectedRange];
  return become;
}

- (void)setText:(NSString *)text {
  
  NSString *editingText = [text stringByReplacingOccurrencesOfString:_detailedText withString:@""];
  if (editingText.length) {
    editingText = [editingText stringByAppendingString:_detailedText];
  }
  [super setText:editingText];
  [self updateSelectedRange];
  
}

- (NSString *)text {
  return super.text;
  NSString *text = super.text;
  if (_detailedText.length) {
    text = [text stringByReplacingOccurrencesOfString:_detailedText withString:@""];
  }
  return text;
  
}

- (void)updateSelectedRange {

  UITextPosition *endPosition = [self positionFromPosition:self.endOfDocument offset:-_detailedText.length];
  self.selectedTextRange = [self textRangeFromPosition:endPosition toPosition:endPosition];
  
}

@end
