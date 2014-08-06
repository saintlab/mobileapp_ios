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

- (id)initWithFrame:(CGRect)frame {
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
  
  NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textField]|" options:0 metrics:nil views:views];
  [self addConstraints:h];
  
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[colorView]|" options:0 metrics:nil views:views];
  [self addConstraints:h];
  
  h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[errorLabel]|" options:0 metrics:nil views:views];
  [self addConstraints:h];
  
  NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textField(45)][colorView(1)]-[errorLabel]|" options:0 metrics:nil views:views];
  [self addConstraints:v];
  
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
