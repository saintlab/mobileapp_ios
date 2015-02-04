//
//  OMNErrorTextField.m
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNErrorTextField.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "OMNClearButton.h"

@interface OMNErrorTextField ()

@end

@implementation OMNErrorTextField {
  UIView *_colorView;
  UILabel *_errorLabel;
  Class _textFieldClass;
  BOOL _error;
}

- (instancetype)initWithWidth:(CGFloat)width textFieldClass:(Class)textFieldClass {
  
  _controlWidth = width;
  _textFieldClass = textFieldClass;
  self = [super init];
  if (self) {
  }
  return self;
}

- (instancetype)initWithWidth:(CGFloat)width {
  
  self = [self initWithWidth:width textFieldClass:[UITextField class]];
  if (self) {
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
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
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  if (nil == _textFieldClass) {
    _textFieldClass = [UITextField class];
  }
  
  _textField = [[[_textFieldClass class] alloc] init];
  _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _textField.textColor = [UIColor blackColor];
  _textField.font = FuturaLSFOmnomLERegular(22.0f);
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _textField.autocorrectionType = UITextAutocorrectionTypeNo;
  [self addSubview:_textField];
  
  _textField.rightView = [OMNClearButton omn_clearButtonWithTargett:self action:@selector(clearTextField)];
  _textField.rightViewMode = UITextFieldViewModeWhileEditing;
  
  _colorView = [[UIView alloc] init];
  _colorView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_colorView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.numberOfLines = 0;
  _errorLabel.font = FuturaLSFOmnomLERegular(18.0f);
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _errorLabel.textColor = colorWithHexString(@"D0021B");
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_errorLabel];
  
  NSDictionary *views =
  @{
    @"textField" : _textField,
    @"colorView" : _colorView,
    @"errorLabel" : _errorLabel,
    };
  
  if (_controlWidth > 0.0f) {
    NSDictionary *metrics = @{@"width" : @(_controlWidth)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[colorView(width)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[textField(width)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_textField attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    
  }
  else {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorView]|" options:0 metrics:nil views:views]];
  }
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField(>=45)][colorView(1)]-[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self updateColorView];
  
  [_textField addTarget:self action:@selector(updateColorView) forControlEvents:UIControlEventEditingDidBegin];
  [_textField addTarget:self action:@selector(updateColorView) forControlEvents:UIControlEventEditingDidEnd];
  [_textField addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventEditingChanged];
  
}

- (void)clearTextField {
  
  _textField.text = @"";
  
}

- (void)valueChanged {
  
  [self setErrorText:nil];
  
}

- (BOOL)becomeFirstResponder {
  return [_textField becomeFirstResponder];
}

- (void)setError:(BOOL)isError {
  
  _error = isError;
  [self updateColorView];
  
}

- (void)setErrorText:(NSString *)text {

  [self setError:(text.length > 0)];
  
  if (0 == text.length &&
      _errorLabel.text.length) {
  
    _errorLabel.text = text;
    [UIView animateWithDuration:0.3 animations:^{
      _errorLabel.alpha = 0.0f;
      [self.superview layoutIfNeeded];
    }];

  }
  else {
    
    _errorLabel.alpha = 1.0f;
    _errorLabel.text = text;
    
  }
  
}

- (void)updateColorView {
  
  if (_error) {
    _colorView.backgroundColor = colorWithHexString(@"D0021B");
  }
  else if(_textField.editing) {
    _colorView.backgroundColor = [UIColor blackColor];
  }
  else {
    _colorView.backgroundColor = [colorWithHexString(@"787878") colorWithAlphaComponent:0.3f];
  }
  
}

@end
