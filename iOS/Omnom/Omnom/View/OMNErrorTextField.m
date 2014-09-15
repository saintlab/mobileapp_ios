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

@interface OMNErrorTextField ()

@property (nonatomic, strong, readonly) UITextView *errorTextView;

@end

@implementation OMNErrorTextField {
  UIView *_colorView;
  CGFloat _width;
}

- (instancetype)initWithWidth:(CGFloat)width {
  _width = width;
  self = [super init];
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
  
  _textField = [[UITextField alloc] init];
  _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _textField.textColor = [UIColor blackColor];
  _textField.font = FuturaLSFOmnomRegular(20.0f);
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _textField.autocorrectionType = UITextAutocorrectionTypeNo;
  [self addSubview:_textField];
  
  _colorView = [[UIView alloc] init];
  _colorView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_colorView];
  
  
  _errorTextView = [[UITextView alloc] init];
  _errorTextView.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _errorTextView.translatesAutoresizingMaskIntoConstraints = NO;
  _errorTextView.textColor = colorWithHexString(@"D0021B");
  _errorTextView.textAlignment = NSTextAlignmentCenter;
  _errorTextView.scrollEnabled = NO;
  _errorTextView.editable = NO;
  _errorTextView.textContainer.lineFragmentPadding = 0;
  _errorTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
  [self addSubview:_errorTextView];
  
  NSDictionary *views =
  @{
    @"textField" : _textField,
    @"colorView" : _colorView,
    @"errorLabel" : _errorTextView,
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:views]];
  
  if (_width > 0.0f) {
    NSDictionary *metrics = @{@"width" : @(_width)};
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[colorView(width)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_colorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  }
  else {
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorView]|" options:0 metrics:nil views:views]];
  }
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField(>=45)][colorView(1)]-[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self updateColorView];
  
  [_textField addTarget:self action:@selector(updateColorView) forControlEvents:UIControlEventEditingDidBegin];
  [_textField addTarget:self action:@selector(updateColorView) forControlEvents:UIControlEventEditingDidEnd];
  [_textField addTarget:self action:@selector(editingChanged) forControlEvents:UIControlEventEditingChanged];
  
}

- (void)editingChanged {
  [self setError:nil];
}

- (BOOL)becomeFirstResponder {
  return [_textField becomeFirstResponder];
}

- (void)setError:(NSString *)text {
  
  _errorTextView.text = text;
  [self layoutIfNeeded];
  [self updateColorView];
  
}

- (void)updateColorView {
  
  if (_errorTextView.text.length ||
      _errorTextView.attributedText.length) {
    _colorView.backgroundColor = colorWithHexString(@"D0021B");
  }
  else if(_textField.editing) {
    _colorView.backgroundColor = [UIColor blackColor];
  }
  else {
    _colorView.backgroundColor = colorWithHexString(@"787878");
  }
  
}

@end
