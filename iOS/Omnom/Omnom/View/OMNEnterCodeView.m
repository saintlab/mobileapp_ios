//
//  OMNEnterCodeView.m
//  seocialtest
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEnterCodeView.h"
#import <OMNStyler.h>

@interface OMNEnterCodeTextField : UITextField

@end

@interface OMNEnterCodeView ()
<UITextFieldDelegate>

@end

@implementation OMNEnterCodeView {
  NSArray *_labels;
  NSString *_code;
}

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

- (BOOL)becomeFirstResponder {
  return [[_labels firstObject] becomeFirstResponder];
}

- (void)setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  NSMutableArray *labels = [NSMutableArray arrayWithCapacity:4];
  
  for (int i = 0; i < 4; i++) {
    OMNEnterCodeTextField *label = [[OMNEnterCodeTextField alloc] init];
    label.delegate = self;
    [self addSubview:label];
    [labels addObject:label];
  }
  _labels = labels;

  NSDictionary *views =
  @{
    @"l1": _labels[0],
    @"l2": _labels[1],
    @"l3": _labels[2],
    @"l4": _labels[3],
    };

  NSDictionary *metrics =
  @{
    @"offset" : @(6.0f),
    @"width" : @(23.0f),
    @"height" : @(40.0f),
    };

  NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[l1(width)]-(offset)-[l2(width)]-(offset)-[l3(width)]-(offset)-[l4(width)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:h];
  
  NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l1(height)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l2(height)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l3(height)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l4(height)]|" options:kNilOptions metrics:metrics views:views];
  [self addConstraints:v];
  
  self.code = @"";
  
}

- (void)setCode:(NSString *)code {
  
  _code = code;
  
  [_labels enumerateObjectsUsingBlock:^(OMNEnterCodeTextField *enterCodeTextField, NSUInteger idx, BOOL *stop) {
    
    if (idx < code.length) {
    
      char ch = [code characterAtIndex:idx];
      enterCodeTextField.text = [NSString stringWithFormat:@"%c", ch];
    }
    else {
      enterCodeTextField.text = @"";
    }
    
    if (idx == code.length) {
      [enterCodeTextField becomeFirstResponder];
    }
    
  }];
  
  if (code.length == _labels.count) {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }
  
}

- (NSString *)code {
  return _code;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  if (!self.enabled) {
    return NO;
  }
  
  if (0 == string.length) {
    if (_code.length) {
      _code = [_code substringToIndex:_code.length - 1];
    }
    [self setCode:_code];
    return NO;
  }
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  NSArray *components = [finalString componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]];
  finalString = [components componentsJoinedByString:@""];
  if (finalString.length > 1) {
    finalString = [finalString substringToIndex:1];
  }
  textField.text = finalString;
  
  if (finalString.length) {
    NSString *code = [_code stringByAppendingString:finalString];
    [self setCode:code];
  }
  
  return NO;
}

@end

@implementation OMNEnterCodeTextField

- (instancetype)init {
  self = [super init];
  if (self) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.textAlignment = NSTextAlignmentCenter;
    self.keyboardType = UIKeyboardTypeNumberPad;
    self.font = FuturaLSFOmnomLERegular(25.0f);
    self.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void)deleteBackward {
  [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
}

- (void)setText:(NSString *)text {
  [super setText:text];
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];
  
  if (0 == self.text.length) {

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat height = CGRectGetHeight(self.frame);
    [self.textColor set];
    CGContextMoveToPoint(ctx, 0.0f, height - 0.5f);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.frame), height - 0.5f);
    CGContextStrokePath(ctx);
    
  }
}

@end

