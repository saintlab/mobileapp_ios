//
//  OMNLunchOrderAlertVC.m
//  omnom
//
//  Created by tea on 25.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLunchOrderAlertVC.h"
#import "OMNUtils.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIView+omn_autolayout.h"
#import "OMNRestaurantAddressSelectionVC.h"
#import "OMNDateSelectionVC.h"
#import "OMNRestaurantDelivery.h"
#import "NSString+omn_date.h"

@implementation OMNLunchOrderAlertVC {
  
  UILabel *_textLabel;
  UIButton *_dateButton;
  UIView *_dateLine;
  UIButton *_addressButton;
  UIView *_addressLine;
  OMNRestaurant *_restaurant;
  UIButton *_doneButton;
  
  OMNRestaurantDelivery *_delivery;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _delivery = [[OMNRestaurantDelivery alloc] init];
  _delivery.date = [_restaurant.delivery_dates firstObject];
  [self createViews];
  [self configureViews];
  [self updateButtons];
  
}

- (void)doneTap {
  
  if (self.didSelectRestaurantBlock &&
      _delivery.readyForDelivery) {

    self.didSelectRestaurantBlock([_restaurant restaurantWithDelivery:_delivery]);
    
  }
  
}

- (void)addressTap {
  
  OMNRestaurantAddressSelectionVC *restaurantAddressSelectionVC = [[OMNRestaurantAddressSelectionVC alloc] initWithRestaurant:_restaurant];
  @weakify(self)
  restaurantAddressSelectionVC.didSelectRestaurantAddressBlock = ^(OMNRestaurantAddress *restaurantAddress) {
    
    @strongify(self)
    [self didSelectAddress:restaurantAddress];
    [self dismissViewControllerAnimated:YES completion:nil];
    
  };
  restaurantAddressSelectionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:restaurantAddressSelectionVC] animated:YES completion:nil];
  
}

- (void)dateTap {
  
  OMNDateSelectionVC *dateSelectionVC = [[OMNDateSelectionVC alloc] initWithDates:_restaurant.delivery_dates];
  @weakify(self)
  dateSelectionVC.didSelectDateBlock = ^(NSString *date) {
    
    @strongify(self)
    [self didSelectDate:date];
    [self dismissViewControllerAnimated:YES completion:nil];

  };
  dateSelectionVC.didCloseBlock = ^{
    
    @strongify(self)
    [self dismissViewControllerAnimated:YES completion:nil];
    
  };
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:dateSelectionVC] animated:YES completion:nil];
  
}

- (void)didSelectAddress:(OMNRestaurantAddress *)address {
  
  _delivery.address = address;
  [self updateButtons];

}

- (void)didSelectDate:(NSString *)date {
  
  _delivery.date = date;
  [self updateButtons];
  
}

- (void)updateButtons {
  
  UIColor *officeColor = nil;
  if (_delivery.address) {
    
    [_addressButton setTitle:_delivery.address.text forState:UIControlStateNormal];
    officeColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
    
  }
  else {
    
    [_addressButton setTitle:kOMN_LUNCH_ALERT_SELECT_OFFICE_TITLE forState:UIControlStateNormal];
    officeColor = [OMNStyler redColor];
    
  }
  [_addressButton setTitleColor:officeColor forState:UIControlStateNormal];
  _addressLine.backgroundColor = officeColor;

  UIColor *dateColor = nil;
  if (_delivery.date) {
    
    [_dateButton setTitle:[_delivery.date omn_localizedWeekday] forState:UIControlStateNormal];
    dateColor = [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f];
    
  }
  else {
    
    [_addressButton setTitle:kOMN_LUNCH_ALERT_SELECT_DATE_TITLE forState:UIControlStateNormal];
    dateColor = [OMNStyler redColor];
    
  }
  [_dateButton setTitleColor:dateColor forState:UIControlStateNormal];
  _dateLine.backgroundColor = dateColor;
  
  _doneButton.enabled = _delivery.readyForDelivery;
  
}

- (void)configureViews {

  _textLabel.font = FuturaOSFOmnomRegular(18.0f);
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.text = kOMN_ORDER_LUNCH_ALERT_TITLE;
  
  _doneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_doneButton addTarget:self action:@selector(doneTap) forControlEvents:UIControlEventTouchUpInside];
  [_doneButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateDisabled];
  [_doneButton setTitle:kOMN_OK_BUTTON_TITLE forState:UIControlStateNormal];
  
  _dateButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_dateButton addTarget:self action:@selector(dateTap) forControlEvents:UIControlEventTouchUpInside];
  
  _addressButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_addressButton addTarget:self action:@selector(addressTap) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)createViews {
  
  _textLabel = [UILabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  [self.contentView addSubview:_textLabel];
  
  _dateButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_dateButton];
  
  _addressButton = [UIButton omn_autolayoutView];
  _addressButton.titleLabel.numberOfLines = 0;
  [self.contentView addSubview:_addressButton];
  
  _dateLine = [UIView omn_autolayoutView];
  [self.contentView addSubview:_dateLine];
  
  _addressLine = [UIView omn_autolayoutView];
  [self.contentView addSubview:_addressLine];
  
  _doneButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_doneButton];
  
  NSDictionary *views =
  @{
    @"textLabel" : _textLabel,
    @"dateButton" : _dateButton,
    @"dateLine" : _dateLine,
    @"addressLine" : _addressLine,
    @"addressButton" : _addressButton,
    @"doneButton" : _doneButton,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-2*[OMNStyler styler].leftOffset.floatValue]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_dateButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:10.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_dateLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeWidth multiplier:1.0f constant:-2*[OMNStyler styler].leftOffset.floatValue]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLine attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_addressButton attribute:NSLayoutAttributeWidth multiplier:1.0f constant:10.0f]];
  [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_addressLine attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
  
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textLabel]-(leftOffset)-[dateButton][dateLine(1)]-(leftOffset)-[addressButton][addressLine(1)]-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}

@end
