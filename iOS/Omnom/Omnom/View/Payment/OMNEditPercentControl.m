//
//  OMNPercentControl.m
//  omnom
//
//  Created by tea on 19.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNEditPercentControl.h"
#import "OMNConstants.h"
#import <OMNStyler.h>

@interface OMNEditPercentControl ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UITextFieldDelegate>

@property (nonatomic, strong, readonly) UITextField *percentTF;

@end

@implementation OMNEditPercentControl {
  
  UIPickerView *_percentPicker;
  UIView *_flexibleBottomView;
  
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [super initWithCoder:coder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)configureWithColor:(UIColor *)color antogonistColor:(UIColor *)antogonistColor {
  
  _percentTF.tintColor = antogonistColor;
  
}

- (BOOL)resignFirstResponder {
  
  [super resignFirstResponder];
  BOOL result = [_percentTF resignFirstResponder];
  [UIView animateWithDuration:0.3 animations:^{
    
    self.percentTF.alpha = 0.0f;
    
  }];
  [self sendActionsForControlEvents:UIControlEventEditingDidEnd];
  return result;
  
}

- (BOOL)becomeFirstResponder {
  
  [UIView animateWithDuration:0.3 animations:^{
    
    self.percentTF.alpha = 1.0f;
    
  }];
  [self sendActionsForControlEvents:UIControlEventEditingDidBegin];
  return [_percentTF becomeFirstResponder];
  
}

- (void)setPercent:(double)percent {
  
  _percent = percent;
  _percentTF.text = [NSString stringWithFormat:@"%.0f%%", percent];
  
  if (percent < [_percentPicker numberOfRowsInComponent:0]) {
    
    [_percentPicker selectRow:(NSInteger)round(percent) inComponent:0 animated:NO];
    
  }
  else {
    
    [_percentPicker selectRow:0 inComponent:0 animated:NO];
    
  }
  
}

#pragma mark - UIPickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [NSString stringWithFormat:@"%ld%%", (long)row];
  
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  
  return 201;
  
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  
  return 1;
  
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  self.percent = (double)row;
  [self sendActionsForControlEvents:UIControlEventValueChanged];
  
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  
  return NO;
  
}

- (void)setup {
  
  self.backgroundColor = [UIColor clearColor];
  
  _percentPicker = [[UIPickerView alloc] init];
  _percentPicker.backgroundColor = [UIColor whiteColor];
  _percentPicker.delegate = self;
  _percentPicker.dataSource = self;
  
  _percentTF = [[UITextField alloc] init];
  _percentTF.translatesAutoresizingMaskIntoConstraints = NO;
  _percentTF.textAlignment = NSTextAlignmentCenter;
  _percentTF.inputView = _percentPicker;
  _percentTF.adjustsFontSizeToFitWidth = YES;
  _percentTF.minimumFontSize = 10.0f;
  _percentTF.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
  _percentTF.font = FuturaLSFOmnomLERegular(50.0f);
  _percentTF.textColor = [UIColor whiteColor];
  [self addSubview:_percentTF ];
  
  _flexibleBottomView = [[UIView alloc] init];
  _flexibleBottomView.translatesAutoresizingMaskIntoConstraints = NO;
  _flexibleBottomView.backgroundColor = colorWithHexString(@"FFFFFF");
  [self addSubview:_flexibleBottomView];
  
  NSDictionary *views =
  @{
    @"flexibleBottomView" : _flexibleBottomView,
    @"percentTF" : _percentTF,
    };
  
  NSDictionary *metrics =
  @{
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[percentTF]-2-[flexibleBottomView(1)]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[percentTF]|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[flexibleBottomView]|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
