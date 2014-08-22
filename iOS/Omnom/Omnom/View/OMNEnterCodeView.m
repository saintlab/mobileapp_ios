//
//  OMNEnterCodeView.m
//  seocialtest
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEnterCodeView.h"

@interface OMNEnterCodeLabel : UILabel

@end

@interface OMNEnterCodeView ()
<UITextFieldDelegate>

@end

@implementation OMNEnterCodeView {
  NSArray *_labels;
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
  return [_textField becomeFirstResponder];
}

- (void)setup {
  
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  _textField = [[UITextField alloc] init];
  _textField.keyboardType = UIKeyboardTypeDecimalPad;
  _textField.delegate = self;
  [self addSubview:_textField];
  
  NSMutableArray *labels = [NSMutableArray arrayWithCapacity:4];
  
  for (int i = 0; i < 4; i++) {
    OMNEnterCodeLabel *label = [[OMNEnterCodeLabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:30.0f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
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

  NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[l1(width)]-(offset)-[l2(width)]-(offset)-[l3(width)]-(offset)-[l4(width)]|" options:0 metrics:metrics views:views];
  [self addConstraints:h];
  
  NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l1(height)]|" options:0 metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l2(height)]|" options:0 metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l3(height)]|" options:0 metrics:metrics views:views];
  [self addConstraints:v];
  v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[l4(height)]|" options:0 metrics:metrics views:views];
  [self addConstraints:v];
  
  self.code = @"";
  
}

- (void)setCode:(NSString *)code {
  
  _textField.text = code;
  
  [_labels enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
    
    if (idx < code.length) {
    
      char ch = [code characterAtIndex:idx];
      label.text = [NSString stringWithFormat:@"%c", ch];
    }
    else {
      label.text = @"";
    }
    
  }];
  
  if (code.length == _labels.count) {
    [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  }
  
}

- (NSString *)code {
  return _textField.text;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  textField.text = finalString;
  [self setCode:finalString];
  
  return NO;
}

@end

@implementation OMNEnterCodeLabel

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

