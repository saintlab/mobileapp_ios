//
//  OMNDotTextField.m
//  dotTest
//
//  Created by tea on 23.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDotTextField.h"
#import "OMNUtils.h"
#import <AudioToolbox/AudioToolbox.h>

@interface OMNCommaButton : UIButton

@end

@interface OMNDotTextField ()

@end

@implementation OMNDotTextField {
  UIButton *_commaButton;
}

- (void)dealloc {
  [self editingDidEnd];
}

- (instancetype)init {
  self = [super init];
  if (self) {
    [self setupDotView];
  }
  return self;
}

- (void)awakeFromNib {
  [self setupDotView];
}

- (void)setupDotView {
  
  self.keyboardType = UIKeyboardTypeDecimalPad;
//  [self addTarget:self action:@selector(editingDidBegin) forControlEvents:UIControlEventEditingDidBegin];
//  [self addTarget:self action:@selector(editingDidEnd) forControlEvents:UIControlEventEditingDidEnd];
  
}

- (void)editingDidBegin {
  
  _commaButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 163, 106, 53)];
  _commaButton.adjustsImageWhenHighlighted = NO;
  _commaButton.titleLabel.font = [UIFont systemFontOfSize:25.0f];
  [_commaButton addTarget:self action:@selector(commaTap:) forControlEvents:UIControlEventTouchUpInside];
  [_commaButton setTitle:omnCommaString() forState:UIControlStateNormal];
  [_commaButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [_commaButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [_commaButton setBackgroundImage:[UIImage imageNamed:@"dot_button_bg"] forState:UIControlStateNormal];

  dispatch_async(dispatch_get_main_queue(), ^{
    
    UIView *keyboardView = [[[UIApplication sharedApplication] windows] lastObject];
    [_commaButton setFrame:CGRectMake(0, keyboardView.frame.size.height - 53, 106, 53)];
    [keyboardView addSubview:_commaButton];
    [keyboardView bringSubviewToFront:_commaButton];
    
  });
  
}

- (NSRange)omn_selectedRange {
  UITextPosition* beginning = self.beginningOfDocument;
  UITextRange* selectedRange = self.selectedTextRange;
  UITextPosition* selectionStart = selectedRange.start;
  UITextPosition* selectionEnd = selectedRange.end;
  
  const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
  const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
  
  return NSMakeRange(location, length);
}

- (void)commaTap:(UIButton *)b { 

  NSRange selectedRange = [self omn_selectedRange];
  
  if (self.delegate &&
      [self.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
    
    if ([self.delegate textField:self shouldChangeCharactersInRange:selectedRange replacementString:omnCommaString()]) {
      [self addComma];
    }
    
  }
  else {
    [self addComma];
  }
  
}

- (void)addComma {
  [self replaceRange:[self selectedTextRange] withText:omnCommaString()];
}

- (void)editingDidEnd {
  [_commaButton removeFromSuperview];
  _commaButton = nil;
}

@end

@implementation OMNCommaButton

@end
