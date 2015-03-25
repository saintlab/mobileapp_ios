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

@implementation OMNLunchOrderAlertVC {
  
  UILabel *_textLabel;
  UIButton *_dateButton;
  UIView *_dateLine;
  UIButton *_addressButton;
  UIView *_addressLine;
  OMNRestaurant *_restaurant;
  UIButton *_doneButton;
  
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
  
  [self createViews];
  [self configureViews];
  
}

- (void)configureViews {

  _textLabel.font = FuturaOSFOmnomRegular(18.0f);
  _textLabel.textAlignment = NSTextAlignmentCenter;
  _textLabel.text = NSLocalizedString(@"ORDER_LUNCH_ALERT_TITLE", @"Заказ обада в офис");
  
  _doneButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_doneButton setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
  [_doneButton setTitleColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f] forState:UIControlStateHighlighted];
  [_doneButton setTitle:NSLocalizedString(@"Ok", @"Ok") forState:UIControlStateNormal];
  
  _dateButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_dateButton setTitle:@"На завтра, 19 марта" forState:UIControlStateNormal];
  [_dateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  
  _addressButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_addressButton setTitle:@"Банк интеза, Октябрьская 49" forState:UIControlStateNormal];
  [_addressButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  
  _dateLine.backgroundColor = [UIColor lightGrayColor];
  _addressLine.backgroundColor = [UIColor lightGrayColor];
  
}

- (void)createViews {
  
  _textLabel = [UILabel omn_autolayoutView];
  _textLabel.numberOfLines = 0;
  [self.contentView addSubview:_textLabel];
  
  _dateButton = [UIButton omn_autolayoutView];
  [self.contentView addSubview:_dateButton];
  
  _addressButton = [UIButton omn_autolayoutView];
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
  
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textLabel]-[dateButton][dateLine(1)]-[addressButton][addressLine(1)]-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[textLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[dateButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[addressButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[addressLine]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[dateLine]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[doneButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  
}




@end
