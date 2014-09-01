//
//  GSplitSelectionVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSplitSelectionVC.h"
#import <UITextField+BlocksKit.h>

@interface OMNSplitSelectionVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@end

@implementation OMNSplitSelectionVC {
  
  __weak IBOutlet UILabel *_numberOfGuestsLabel;
  __weak IBOutlet UIPickerView *_numberOfGuestsPicker;
  
  NSInteger _numberOfGuests;
  
  long long _total;
}

- (void)dealloc {
  
}

- (instancetype)initWIthTotal:(long long)total {
  self = [super init];
  if (self) {
    _total = total;
  }
  return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  [self setNumberOfGuests:1];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self updateTotalValue];
}

- (void)updateTotalValue {
  
  [self.delegate totalDidChange:ceil((double)_total / _numberOfGuests)];
  
}

- (void)setNumberOfGuests:(NSInteger)numberOfGuests {
  
  _numberOfGuests = MAX(1, numberOfGuests);
  _numberOfGuestsLabel.text = [NSString stringWithFormat:@"%ld", (long)_numberOfGuests];
  [_numberOfGuestsPicker selectRow:_numberOfGuests - 1 inComponent:0 animated:NO];
  
  [self updateTotalValue];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UIPickerView

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  
  return [NSString stringWithFormat:@"%ld", (long)row + 1];
  
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  return 40;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  
  self.numberOfGuests = row + 1;
  
}

@end
