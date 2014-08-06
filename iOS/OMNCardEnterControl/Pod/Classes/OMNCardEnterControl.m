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

@interface OMNCardEnterControl ()
<UITextFieldDelegate>

@end

@implementation OMNCardEnterControl {
  UITextField *_panTF;
  UITextField *_expireTF;
  UITextField *_cvvTF;
  UIButton *_saveButton;
  
  CGSize _panSize;
  CGFloat _expireWidth;
  
  NSDictionary *_views;
  NSDictionary *_metrics;
  
  NSMutableArray *_dynamycConstraints;
  
  BOOL _expireCCVTFHidden;
}

- (instancetype)init {
  
  self = [super initWithFrame:(CGRect){CGPointZero, _panSize}];
  if (self) {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.backgroundColor = [UIColor clearColor];

    _dynamycConstraints = [NSMutableArray array];
    
    UIButton *cameraButton = [[UIButton alloc] init];
    [cameraButton setImage:[UIImage imageNamed:@"camera_icon"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(cameraButtonTap) forControlEvents:UIControlEventTouchUpInside];
    [cameraButton sizeToFit];
    
    _panTF = [[OMNDeletedTextField alloc] init];
    _panTF.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _panTF.rightViewMode = UITextFieldViewModeAlways;
    _panTF.rightView = cameraButton;
    _panTF.translatesAutoresizingMaskIntoConstraints = NO;
    _panTF.placeholder = NSLocalizedString(@"Номер банковской карты", nil);
    _panTF.keyboardType = UIKeyboardTypeNumberPad;
    _panTF.delegate = self;
    [self addSubview:_panTF];

    _expireTF = [[OMNDeletedTextField alloc] init];
    _expireTF.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _expireTF.textAlignment = NSTextAlignmentLeft;
    _expireTF.translatesAutoresizingMaskIntoConstraints = NO;
    _expireTF.keyboardType = UIKeyboardTypeNumberPad;
    _expireTF.delegate = self;
    _expireTF.placeholder = [NSString stringWithFormat:@"MM%@YY", kMM_YYSeporator];
    [self addSubview:_expireTF];
    
    _cvvTF = [[OMNDeletedTextField alloc] init];
    _cvvTF.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _cvvTF.textAlignment = NSTextAlignmentLeft;
    _cvvTF.translatesAutoresizingMaskIntoConstraints = NO;
    _cvvTF.keyboardType = UIKeyboardTypeNumberPad;
    _cvvTF.delegate = self;
    _cvvTF.placeholder = @"CVV";
    [self addSubview:_cvvTF];
    
    _saveButton = [[UIButton alloc] init];
    [_saveButton addTarget:self action:@selector(saveTap) forControlEvents:UIControlEventTouchUpInside];
    _saveButton.translatesAutoresizingMaskIntoConstraints = NO;
    _saveButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    _saveButton.titleLabel.numberOfLines = 0;
    _saveButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:15.0f];
    _saveButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _saveButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _saveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _saveButton.tintColor = [UIColor blackColor];
    [_saveButton setImage:[UIImage imageNamed:@"not_selected_check_box_icon"] forState:UIControlStateNormal];
    [_saveButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_saveButton setImage:[UIImage imageNamed:@"selected_check_box_icon"] forState:UIControlStateSelected];
    [_saveButton setImage:[UIImage imageNamed:@"selected_check_box_icon"] forState:UIControlStateSelected|UIControlStateHighlighted];
    _saveButton.titleLabel.minimumScaleFactor = 0.1f;
    [_saveButton setTitle:NSLocalizedString(@"Сохранить данные для следующих платежей", nil) forState:UIControlStateNormal];
    [self addSubview:_saveButton];
    
    self.clipsToBounds = YES;
    
    _views =
    @{
      @"panTF" : _panTF,
      @"cvvTF" : _cvvTF,
      @"expireTF" : _expireTF,
      @"saveButton" : _saveButton,
      };
    
    _metrics =
    @{
      @"saveButtonHeight" : @(50.0f),
      @"height" : @(50.0f),
      };
    
    NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[panTF]|" options:0 metrics:nil views:_views];
    [self addConstraints:panH];
    
    panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[saveButton]|" options:0 metrics:nil views:_views];
    [self addConstraints:panH];
    
    panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[expireTF]-[cvvTF]" options:0 metrics:nil views:_views];
    [self addConstraints:panH];
    
    NSArray *panV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panTF(height)]" options:0 metrics:_metrics views:_views];
    [self addConstraints:panV];
      NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_cvvTF attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_expireTF attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self addConstraint:centerYConstraint];
    
    NSArray *equalVConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cvvTF(==expireTF)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:_views];
    [self addConstraints:equalVConstraints];
    [self setExpireCCVTFHidden:YES animated:NO completion:nil];
    
  }
  return self;
}

- (void)cameraButtonTap {
  [self.delegate cardEnterControlDidRequestScan:self];
}

- (void)saveTap {
  _saveButton.selected = !_saveButton.selected;
}

- (BOOL)saveButtonSelected {
  return _saveButton.selected;
}

- (void)setExpireCCVTFHidden:(BOOL)hidden animated:(BOOL)animated completion:(dispatch_block_t)completion {

  NSMutableArray *dynamycConstraints = [NSMutableArray array];
  if (hidden) {
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panTF(height)]-[expireTF(0)]-[saveButton(saveButtonHeight)]|" options:0 metrics:_metrics views:_views];
    [dynamycConstraints addObjectsFromArray:constraintsV];
  }
  else {
    NSArray *constraintsV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[panTF(height)]-[expireTF(50)]-[saveButton(saveButtonHeight)]|" options:0 metrics:_metrics views:_views];
    [dynamycConstraints addObjectsFromArray:constraintsV];
  }
  
  [self removeConstraints:_dynamycConstraints];
  _dynamycConstraints = dynamycConstraints;
  [self addConstraints:_dynamycConstraints];

  if (animated) {

    [UIView animateWithDuration:0.3f animations:^{
      [self layoutIfNeeded];
    } completion:^(BOOL finished) {
      
      if (completion) {
        completion();
      }
      
    }];
    
  }
  else {
    [self layoutIfNeeded];
    if (completion) {
      completion();
    }
  }
  _expireCCVTFHidden = hidden;
}

- (void)showExpireTF {
  
  if (_panTF.text.length < kDesiredPanLength) {
    return;
  }
  
  if (_expireCCVTFHidden) {

    [self setExpireCCVTFHidden:NO animated:YES completion:^{
      
      [_expireTF becomeFirstResponder];
      
    }];
    
  }
  else {
    [_expireTF becomeFirstResponder];
  }
  
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
  
  if (0 == _cvvTF.text.length &&
      0 == _expireTF.text.length) {
    
    [self setExpireCCVTFHidden:YES animated:YES completion:^{
      [_panTF becomeFirstResponder];
    }];
  }
  else {
    [_panTF becomeFirstResponder];
  }
  
  
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

- (BOOL)isValidDate {
  
  BOOL isValidDate = YES;
  
  
  
  
}

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
    }
    
    NSString *MMYYString = [MM_YYComponents componentsJoinedByString:kMM_YYSeporator];
    NSMutableAttributedString *attributedMMYYString = [[NSMutableAttributedString alloc] initWithString:MMYYString];
    
    if (2 == mm.length &&
        [mm integerValue] > 12) {
      [attributedMMYYString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, MMYYString.length)];
    }
    else if (2 == yy.length &&
        [yy integerValue] < 14) {
      [attributedMMYYString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} range:NSMakeRange(0, MMYYString.length)];
    }
    else {
      [attributedMMYYString setAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:NSMakeRange(0, MMYYString.length)];
    }
    textField.attributedText = attributedMMYYString;

    if (0 == mm.length &&
        [string isEqualToString:@""]) {
      [self showPANTF];
    }
    else if (2 == mm.length &&
             2 == yy.length) {
      [self showCVVTF];
    }
    
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
    else if (0 == cvv.length) {
      [self showExpireTF];
    }
    return NO;
  }
  
  return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  [textField setNeedsDisplay];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  [textField setNeedsDisplay];
}

@end

@implementation OMNDeletedTextField

- (void)deleteBackward {
  if (0 == self.text.length) {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(0, 0) replacementString:@""];
  }
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  UIImage *image = [UIImage imageNamed:(self.editing) ? (@"input_card_number_field_active") : (@"input_card_number_field_no_active")];
  [image drawInRect:CGRectMake(0.0f, CGRectGetHeight(self.frame) - image.size.height, CGRectGetWidth(self.frame), image.size.height)];
  
}

@end
