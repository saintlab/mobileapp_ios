//
//  GSplitSelectionVC.m
//  seocialtest
//
//  Created by tea on 14.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNSplitSelectionVC.h"
#import <OMNStyler.h>
#import "OMNOrderAlertManager.h"
#import "OMNUtils.h"

@interface OMNSplitSelectionVC ()
<UIPickerViewDataSource,
UIPickerViewDelegate>

@end

@implementation OMNSplitSelectionVC {
  
  __weak IBOutlet UILabel *_hintLabel;
  __weak IBOutlet UILabel *_numberOfGuestsLabel;
  __weak IBOutlet UIPickerView *_numberOfGuestsPicker;
  
  NSInteger _numberOfGuests;
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (void)dealloc {
  
}

- (instancetype)initWithMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;

  }
  return self;
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  _hintLabel.text = kOMN_SPLIT_NUMBER_OF_GUESTS_HINT;
  _hintLabel.font = FuturaOSFOmnomRegular(18.0f);
  _hintLabel.textColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
  
  _numberOfGuestsLabel.font = FuturaLSFOmnomLERegular(40.0f);
  _numberOfGuestsLabel.textColor = colorWithHexString(@"000000");
  
  _numberOfGuestsPicker.backgroundColor = [UIColor whiteColor];
  [self setNumberOfGuests:1];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
 
  @weakify(self)
  [OMNOrderAlertManager sharedManager].didUpdateBlock = ^{
    
    @strongify(self)
    [self updateTotalValue];
    
  };
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [self updateTotalValue];
  
}

- (long long)total {
  return _restaurantMediator.table.selectedOrder.totalAmount;
}

- (void)updateTotalValue {
  [self.delegate totalDidChange:ceil((double)self.total / _numberOfGuests) showPaymentButton:YES];
}

- (void)setNumberOfGuests:(NSInteger)numberOfGuests {
  
  _numberOfGuests = MAX(1, numberOfGuests);
  _numberOfGuestsLabel.text = [NSString stringWithFormat:@"%ld", (long)_numberOfGuests];
  [_numberOfGuestsPicker selectRow:_numberOfGuests - 1 inComponent:0 animated:NO];
  
  [self updateTotalValue];
  
}

#pragma mark - UIPickerView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
  
  NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)row + 1] attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(22.0f) textColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter]];
  UILabel *label = [[UILabel alloc] init];
  label.attributedText = attributedTitle;
  return label;
  
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
