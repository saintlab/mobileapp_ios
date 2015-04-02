//
//  OMNSelectMinutesAlertVC.m
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSelectMinutesAlertVC.h"
#import <OMNStyler.h>
#import "OMNConstants.h"
#import "UIView+omn_autolayout.h"
#import "OMNUtils.h"

@interface OMNSelectMinutesAlertVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@end

@implementation OMNSelectMinutesAlertVC {

  UIPickerView *_minutesPicker;
  UIButton *_doneButton;
  NSArray *_minutes;
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
    self.didSelectMinutesBlock(0);
  }
  
}

- (void)configureViews {
  
  _doneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_doneButton addTarget:self action:@selector(doneTap) forControlEvents:UIControlEventTouchUpInside];
  [_doneButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
  [_doneButton setTitle:kOMN_OK_BUTTON_TITLE forState:UIControlStateNormal];
  
  _minutesPicker.delegate = self;
  _minutesPicker.dataSource = self;
  
}

- (void)createViews {

  _minutesPicker = [UIPickerView omn_autolayoutView];
  [self.contentView addSubview:_minutesPicker];
  
  _doneButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_doneButton];
  
  NSDictionary *views =
  @{
    @"minutesPicker" : _minutesPicker,
    @"doneButton" : _doneButton,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[minutesPicker]-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[minutesPicker]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

#pragma mark - picker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return _minutes.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 50.0f;
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _minutes[row]] attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(25.0f) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter]];
  
}

@end
