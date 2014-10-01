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
#import "OMNNonSelectableTextView.h"

@interface OMNErrorTextField ()

@end

@implementation OMNErrorTextField {
  UIView *_colorView;
  UILabel *_label;
  UILabel *_errorLabel;
  Class _textFieldClass;
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
  _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
  _textField.textColor = [UIColor blackColor];
  _textField.font = FuturaLSFOmnomLERegular(22.0f);
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  _textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
  _textField.autocorrectionType = UITextAutocorrectionTypeNo;
  [self addSubview:_textField];
  
  _colorView = [[UIView alloc] init];
  _colorView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_colorView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.numberOfLines = 0;
  _errorLabel.font = FuturaOSFOmnomRegular(18.0f);
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

- (void)setText:(NSString *)text description:(NSString *)description {
  
  self.textField.text = text;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    UITextRange *textRange = [self.textField textRangeFromPosition:self.textField.beginningOfDocument toPosition:self.textField.endOfDocument];
    CGRect textFrame = [self.textField firstRectForRange:textRange];
    
    if (nil == _label) {
      _label = [[UILabel alloc] init];
      [self.textField addSubview:_label];
    }
    
    _label.hidden = (0 == text.length);
    _label.font = self.textField.font;
    _label.textColor = self.textField.textColor;
    _label.text = description;
    [_label sizeToFit];
    CGRect labelFrame = _label.frame;
    labelFrame.origin.x = CGRectGetMaxX(textFrame);
    labelFrame.origin.y = textFrame.origin.y;
    labelFrame.size.height = textFrame.size.height;
    _label.frame = labelFrame;
    
  });
  
}

- (void)valueChanged {
  [self setError:nil];
  _label.hidden = (0 == _textField.text.length);
}

- (BOOL)becomeFirstResponder {
  return [_textField becomeFirstResponder];
}

- (void)setError:(NSString *)text {
  
  _errorLabel.text = text;
  [self layoutIfNeeded];
  [self updateColorView];
  
}

- (void)updateColorView {
  
  if (_errorLabel.text.length) {
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
