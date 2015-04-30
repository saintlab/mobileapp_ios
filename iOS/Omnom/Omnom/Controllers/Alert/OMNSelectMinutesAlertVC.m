//
//  OMNSelectMinutesAlertVC.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSelectMinutesAlertVC.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "OMNUtils.h"
#import "NSString+omn_date.h"

@interface OMNSelectMinutesAlertVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@end

@implementation OMNSelectMinutesAlertVC {

  UIPickerView *_minutesPicker;
  UIButton *_doneButton;
  NSArray *_minutes;
  UILabel *_label;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _minutes =
  @[
    @(15),
    @(30),
    @(45),
    @(60),
    @(90),
    @(120),
    @(180),
    ];
  
  [self createViews];
  [self configureViews];
  
}

- (void)doneTap {
  
  if (self.didSelectMinutesBlock) {
    NSInteger minute = [_minutes[[_minutesPicker selectedRowInComponent:0]] integerValue];
    self.didSelectMinutesBlock(minute);
  }
  
}

- (void)configureViews {
  
  _doneButton.titleLabel.font = FuturaOSFOmnomRegular(20.0f);
  [_doneButton addTarget:self action:@selector(doneTap) forControlEvents:UIControlEventTouchUpInside];
  [_doneButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
  [_doneButton setTitle:kOMN_OK_BUTTON_TITLE forState:UIControlStateNormal];
  
  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.text = kOMN_PREORDER_MINUTES_TEXT;
  _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = colorWithHexString(@"000000");
  
  _minutesPicker.delegate = self;
  _minutesPicker.dataSource = self;
  
}

- (void)createViews {

  _label = [UILabel omn_autolayoutView];
  [self.contentView addSubview:_label];
  
  _minutesPicker = [UIPickerView omn_autolayoutView];
  [self.contentView addSubview:_minutesPicker];
  
  _doneButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_doneButton];
  
  NSDictionary *views =
  @{
    @"minutesPicker" : _minutesPicker,
    @"doneButton" : _doneButton,
    @"label" : _label,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label][minutesPicker][doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minutesPicker]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return _minutes.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 35.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {

  UILabel *label = [[UILabel alloc] init];
  NSInteger minutes = [_minutes[row] integerValue];
  label.attributedText = [[NSAttributedString alloc] initWithString:[NSString omn_takeAfterIntervalString:minutes] attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(25.0f) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter]];
  return label;
  
}

@end
