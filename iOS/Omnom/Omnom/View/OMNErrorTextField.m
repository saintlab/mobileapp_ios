//
//  OMNErrorTextField.m
//  omnom
//
//  Created by tea on 06.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNErrorTextField.h"

@interface OMNErrorTextField ()
<UITextFieldDelegate>

@end

@implementation OMNErrorTextField {
  UIView *_colorView;
  UILabel *_errorLabel;
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
  _textField.delegate = self;
  _textField.textColor = [UIColor blackColor];
  _textField.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
  _textField.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_textField];
  
  _colorView = [[UIView alloc] init];
  _colorView.translatesAutoresizingMaskIntoConstraints = NO;
  [self addSubview:_colorView];
  
  _errorLabel = [[UILabel alloc] init];
  _errorLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:18.0f];
  _errorLabel.textColor = [UIColor redColor];
  _errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
  _errorLabel.numberOfLines = 0;
  _errorLabel.textAlignment = NSTextAlignmentCenter;
  [self addSubview:_errorLabel];
  
  NSDictionary *views =
  @{
    @"textField" : _textField,
    @"colorView" : _colorView,
    @"errorLabel" : _errorLabel,
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorView]|" options:0 metrics:nil views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField(45)][colorView(1)]-[errorLabel]|" options:0 metrics:nil views:views]];
  
  [self updateColorView];
  
}

- (BOOL)becomeFirstResponder {
  return [_textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  [self setError:nil animated:NO];
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [self updateColorView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [self updateColorView];
}

- (void)setError:(NSString *)text animated:(BOOL)animated {
  
  _errorLabel.text = text;
  [self layoutIfNeeded];
  [self updateColorView];
  
}

- (void)updateColorView {
  
  if (_errorLabel.text.length) {
    _colorView.backgroundColor = [UIColor redColor];
  }
  else if(_textField.editing) {
    _colorView.backgroundColor = [UIColor blackColor];
  }
  else {
    _colorView.backgroundColor = [UIColor lightGrayColor];
  }
  
}

@end
