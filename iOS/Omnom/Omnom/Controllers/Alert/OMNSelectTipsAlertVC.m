//
//  OMNSelectTipsAlertVC.m
//  omnom
//
//  Created by tea on 12.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNSelectTipsAlertVC.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "OMNUtils.h"

@interface OMNSelectTipsAlertVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@end

@implementation OMNSelectTipsAlertVC {
  
  UIPickerView *_tipsPicker;
  UIButton *_doneButton;
  UILabel *_label;
  long long _totalAmount;
  
}

- (instancetype)initWithTotalAmount:(long long)totalAmount {
  self = [super init];
  if (self) {
    _totalAmount = totalAmount;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self createViews];
  [self configureViews];
  
}

- (void)doneTap {
  
  if (self.didSelectTipsBlock) {
    self.didSelectTipsBlock(self.selectedTipsAmount);
  }
  
}

- (void)configureViews {
  
  _doneButton.titleLabel.font = PRICE_BUTTON_FONT;
  [_doneButton setBackgroundImage:[[UIImage imageNamed:@"red_roundy_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
  [_doneButton setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateNormal];
  [_doneButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
  [_doneButton addTarget:self action:@selector(doneTap) forControlEvents:UIControlEventTouchUpInside];

  _label.font = FuturaOSFOmnomRegular(20.0f);
  _label.textAlignment = NSTextAlignmentCenter;
  _label.textColor = colorWithHexString(@"000000");
  
  _tipsPicker.delegate = self;
  _tipsPicker.dataSource = self;
  [_tipsPicker selectRow:10 inComponent:0 animated:NO];
  
  [self updateControls];
  
}

- (NSString *)smileFromPercent:(NSInteger)tipsPercentAmount {
  NSString *smile = @"😃";
  if (0 == tipsPercentAmount) {
    smile = @"😞";
  }
  else if (tipsPercentAmount < 3) {
    smile = @"😐";
  }
  else if (tipsPercentAmount < 20) {
    smile = @"😃";
  }
  else {
    smile = @"😎";
  }
  return smile;
}

- (long long)selectedTipsAmount {
  
  NSInteger tipsPercentAmount = [_tipsPicker selectedRowInComponent:0];
  long long tipsAmount = _totalAmount*tipsPercentAmount/100.0;
  return tipsAmount;
  
}

- (void)updateControls {
  
  [UIView transitionWithView:_doneButton duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    [_doneButton setTitle:[NSString stringWithFormat:@"+ %@", [OMNUtils evenMoneyStringFromKop:self.selectedTipsAmount]] forState:UIControlStateNormal];
    
  } completion:nil];
  
  NSInteger tipsPercentAmount = [_tipsPicker selectedRowInComponent:0];
  [UIView transitionWithView:_label duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
    
    _label.text = [NSString stringWithFormat:kOMN_PREORDER_TIPS_FORMAT, [self smileFromPercent:tipsPercentAmount]];
    
  } completion:nil];
  
}

- (void)createViews {
  
  _label = [UILabel omn_autolayoutView];
  [self.contentView addSubview:_label];
  
  _tipsPicker = [UIPickerView omn_autolayoutView];
  [self.contentView addSubview:_tipsPicker];
  
  _doneButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_doneButton];
  
  NSDictionary *views =
  @{
    @"tipsPicker" : _tipsPicker,
    @"doneButton" : _doneButton,
    @"label" : _label,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label][tipsPicker][doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tipsPicker]|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_doneButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
}

#pragma mark - picker

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  [self updateControls];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 101;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return 35.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  
  UILabel *label = [[UILabel alloc] init];
  NSString *percentValue = [NSString stringWithFormat:@"%ld%%", (long)row];
  label.attributedText = [[NSAttributedString alloc] initWithString:percentValue attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(25.0f) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter]];
  return label;
  
}

@end
