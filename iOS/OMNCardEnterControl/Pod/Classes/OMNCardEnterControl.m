//
//  OMNCardEnterControl.m
//  cardEnterControl
//
//  Created by tea on 07.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCardEnterControl.h"

NSString * const OMNCardEnterControlPanString = @"OMNCardEnterControlPanString";
NSString * const OMNCardEnterControlMonthString = @"OMNCardEnterControlMonthString";
NSString * const OMNCardEnterControlYearString = @"OMNCardEnterControlYearString";
NSString * const OMNCardEnterControlCVVString = @"OMNCardEnterControlCVVString";

NSTimeInterval kSlideAnimationDuratiom = 0.5;
NSInteger kDesiredPanLength = 19;
NSInteger kPanGroupLength = 4;
NSInteger kCVVLength = 3;
CGFloat kTextFieldsOffset = 20.0f;
NSString * const kMM_YYSeporator = @"/";

@interface OMNDeletedTextField : UITextField

@end

@interface OMNCardEnterControl ()
<UITextFieldDelegate>

@end

@implementation OMNCardEnterControl {
  UITextField *_panTF;
  UITextField *_expireTF;
  UITextField *_cvvTF;
  
  CGSize _panSize;
  CGFloat _expireWidth;
}

- (instancetype)init {
  
  UIFont *font = [UIFont systemFontOfSize:17];
  
  NSString *panPlaceHolder = @"0000 0000 0000 0000";
  
  _panSize = [panPlaceHolder sizeWithAttributes:@{NSFontAttributeName : font}];
  
  self = [super initWithFrame:(CGRect){CGPointZero, _panSize}];
  if (self) {
    self.backgroundColor = [UIColor lightGrayColor];
    
    _expireWidth = [@"99 / 99" sizeWithAttributes:@{NSFontAttributeName : font}].width;
    
    _expireTF = [[OMNDeletedTextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _expireWidth, CGRectGetHeight(self.frame))];
    _expireTF.keyboardType = UIKeyboardTypeNumberPad;
    _expireTF.font = font;
    _expireTF.delegate = self;
    _expireTF.placeholder = [NSString stringWithFormat:@"MM%@YY", kMM_YYSeporator];
    [self addSubview:_expireTF];
    
    _panTF = [[UITextField alloc] initWithFrame:(CGRect){CGPointZero, _panSize}];
    _panTF.backgroundColor = [UIColor lightGrayColor];
    _panTF.placeholder = panPlaceHolder;
    _panTF.keyboardType = UIKeyboardTypeNumberPad;
    _panTF.font = font;
    _panTF.delegate = self;
    [self addSubview:_panTF];
    
    _cvvTF = [[OMNDeletedTextField alloc] initWithFrame:CGRectMake(0.0f, CGRectGetMaxX(_expireTF.frame), 100.0f, CGRectGetHeight(self.frame))];
    _cvvTF.keyboardType = UIKeyboardTypeNumberPad;
    _cvvTF.font = font;
    _cvvTF.delegate = self;
    _cvvTF.placeholder = @"CVV";
    [self addSubview:_cvvTF];

    
    UIButton *topView = [[UIButton alloc] initWithFrame:self.bounds];
    [topView addTarget:self action:@selector(becomeEditingTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:topView];
    
    self.clipsToBounds = YES;
    
  }
  return self;
}

- (void)becomeEditingTap {
  
  if (_panTF.text.length < kDesiredPanLength) {
    [self showPANTF];
  }
  else {
    [self showExpireTF];
  }
  
}

- (void)showExpireTF {
  
  if (_panTF.text.length < kDesiredPanLength) {
    return;
  }
  
  NSString *displaceString = [_panTF.text substringToIndex:_panTF.text.length - kPanGroupLength];
  CGFloat panOffset = -[displaceString sizeWithAttributes:@{NSFontAttributeName : _panTF.font}].width;
  
  NSString *lastDightsString = [_panTF.text substringFromIndex:_panTF.text.length - kPanGroupLength];
  CGRect frame = _expireTF.frame;
  frame.origin.x = [lastDightsString sizeWithAttributes:@{NSFontAttributeName : _panTF.font}].width + kTextFieldsOffset;
  _expireTF.frame = frame;

  [_expireTF becomeFirstResponder];
  [UIView animateWithDuration:kSlideAnimationDuratiom animations:^{

    _panTF.transform = CGAffineTransformMakeTranslation(panOffset, 0);

  } completion:^(BOOL finished) {
  
  }];
  
}

- (void)setPan:(NSString *)pan {
  _panTF.text = [self panFormatedStringFromPan:pan];
  
  if (_panTF.text.length >= kDesiredPanLength) {
    [self showExpireTF];
  }
  
}

- (NSString *)panFormatedStringFromPan:(NSString *)pan {
  
  NSString *panString = [pan stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  NSMutableArray *panComponents = [NSMutableArray arrayWithCapacity:4];
  for (int component = 0; component < 4; component++) {
    
    NSInteger start = component*kPanGroupLength;
    
    if (start >= panString.length) {
      break;
    }
    
    NSString *componentString = [panString substringWithRange:NSMakeRange(start, MIN(panString.length - start, kPanGroupLength))];
    [panComponents addObject:componentString];
    
  }
  
  return [panComponents componentsJoinedByString:@" "];
  
}

- (void)showPANTF {
  
  [_panTF becomeFirstResponder];
  [UIView animateWithDuration:kSlideAnimationDuratiom animations:^{
    
    _panTF.transform = CGAffineTransformIdentity;
    
  } completion:^(BOOL finished) {
    
  }];
  
}

- (void)showCVVTF {
  
  [_cvvTF becomeFirstResponder];
  
}

- (void)didFinishEnterCardDetails {

  NSString *pan = [_panTF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
  
  NSArray *mmyyComponents = [_expireTF.text componentsSeparatedByString:kMM_YYSeporator];
  NSString *mm = mmyyComponents[0];
  NSString *yy = mmyyComponents[1];

  NSString *cvv = _cvvTF.text;
  
  NSDictionary *cardData =
  @{
    OMNCardEnterControlPanString : pan,
    OMNCardEnterControlMonthString : mm,
    OMNCardEnterControlYearString : yy,
    OMNCardEnterControlCVVString : cvv,
    };
  
  [self.delegate cardEnterControl:self didEnterCardData:cardData];
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

  NSString *finalString = [textField.text stringByReplacingCharactersInRange:range withString:string];
  
  if ([textField isEqual:_panTF]) {
    
    if (finalString.length >= kDesiredPanLength) {
      
      if (finalString.length <= kDesiredPanLength) {
        _panTF.text = finalString;
      }
      [self showExpireTF];
    }
    else {

      NSString *pan = [finalString stringByReplacingOccurrencesOfString:@" " withString:@""];
      _panTF.text = [self panFormatedStringFromPan:pan];
      
    }
    
    return NO;
  }
  else if ([textField isEqual:_expireTF]) {
    
    NSArray *MM_YYComponents = [finalString componentsSeparatedByString:kMM_YYSeporator];
    
    NSString *mm = MM_YYComponents[0];
    NSString *yy = @"";
    
    if (MM_YYComponents.count == 2) {
      
      yy = MM_YYComponents[1];

      if (0 == yy.length &&
          0 == string.length) {
        MM_YYComponents = @[mm];
      }
      
      else if (yy.length >= 2) {
        
        yy = [yy substringToIndex:2];
        NSString *dateString = [@[mm, yy] componentsJoinedByString:kMM_YYSeporator];
        textField.text = dateString;
        [self showCVVTF];
        return NO;
        
      }
      
    }
    else {

      if (mm.length > 2) {
        yy = [mm substringFromIndex:2];
        mm = [mm substringToIndex:2];
        MM_YYComponents = @[mm, yy];
      }
      else if (2 == mm.length) {
        
        if ([string isEqualToString:@""]) {
          MM_YYComponents = @[mm];
        }
        else {
          MM_YYComponents = @[mm, @""];
        }
        
      }
      else if (0 == mm.length &&
               [string isEqualToString:@""]) {
        [self showPANTF];
      }
      
    }
    
    textField.text = [MM_YYComponents componentsJoinedByString:kMM_YYSeporator];
    
    return NO;
  }
  else if ([textField isEqual:_cvvTF]) {
    
    NSString *cvv = finalString;
    
    if (cvv.length > kCVVLength) {
      cvv = [cvv substringToIndex:kCVVLength];
    }
    
    textField.text = cvv;
    
    if (kCVVLength == cvv.length) {
      [self didFinishEnterCardDetails];
    }

  }
  
  return YES;
}

@end

@implementation OMNDeletedTextField

- (void)deleteBackward {
  if (0 == self.text.length) {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
  }
}

@end
