//
//  OMNRestaurantDetailsView.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantDetailsView.h"
#import <OMNStyler.h>
#import "UIButton+omn_helper.h"
#import "OMNUtils.h"
#import "UIView+omn_autolayout.h"
#import <TTTAttributedLabel.h>

@implementation OMNRestaurantDetailsView {
  
  UIButton *_workdayButton;
  TTTAttributedLabel *_restaurantInfoLabelAddress;
  UILabel *_cityLabel;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)setup {
  
  _cityLabel = [UILabel omn_autolayoutView];
  _cityLabel.numberOfLines = 1;
  _cityLabel.textAlignment = NSTextAlignmentCenter;
  _cityLabel.adjustsFontSizeToFitWidth = YES;
  _cityLabel.font = FuturaLSFOmnomLERegular(18.0f);
  _cityLabel.textColor = colorWithHexString(@"000000");
  [self addSubview:_cityLabel];
  
  _restaurantInfoLabelAddress = [TTTAttributedLabel omn_autolayoutView];
  _restaurantInfoLabelAddress.numberOfLines = 0;
  _restaurantInfoLabelAddress.textAlignment = NSTextAlignmentCenter;
  _restaurantInfoLabelAddress.textColor = colorWithHexString(@"000000");
  [self addSubview:_restaurantInfoLabelAddress];
  
  _workdayButton = [UIButton omn_autolayoutView];
  _workdayButton.userInteractionEnabled = NO;
  [_workdayButton omn_centerButtonAndImageWithSpacing:8.0f];
  _workdayButton.titleLabel.font = FuturaLSFOmnomLERegular(18.0f);
  [_workdayButton setTitleColor:colorWithHexString(@"000000") forState:UIControlStateNormal];
  [_workdayButton setImage:[UIImage imageNamed:@"clock_icon"] forState:UIControlStateNormal];
  [self addSubview:_workdayButton];
  
  NSDictionary *views =
  @{
    @"cityLabel" : _cityLabel,
    @"restaurantInfoLabelAddress" : _restaurantInfoLabelAddress,
    @"workdayButton" : _workdayButton,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : @(OMNStyler.leftOffset),
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[cityLabel]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[restaurantInfoLabelAddress]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[workdayButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cityLabel]-(2)-[restaurantInfoLabelAddress]-(leftOffset)-[workdayButton]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)layoutSubviews {
  
  CGFloat preferredMaxLayoutWidth = CGRectGetWidth(self.frame) - 2*OMNStyler.leftOffset;
  _restaurantInfoLabelAddress.preferredMaxLayoutWidth = preferredMaxLayoutWidth;
  [super layoutSubviews];
  
}

- (void)setRestaurant:(OMNRestaurant *)restaurant {
  
  _restaurant = restaurant;
  
  _cityLabel.text = restaurant.address.city;
  NSString *addressText = (_restaurant.address.text) ?: @"";
  NSMutableString *fullAddress = [NSMutableString stringWithString:addressText];
  NSString *distance = @"";

  if (fabs(restaurant.distance) > 1000.0) {
  
    distance = [NSString stringWithFormat:kOMN_RESTAURANT_DISTANCE_KM_FORMAT, restaurant.distance/1000.0];
    
  }
  else if (fabs(restaurant.distance) > 0.0) {
    
    distance = [NSString stringWithFormat:kOMN_RESTAURANT_DISTANCE_M_FORMAT, restaurant.distance];
    
  }
  
  [fullAddress appendString:distance];
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:fullAddress attributes:[OMNUtils textAttributesWithFont:FuturaLSFOmnomLERegular(18.0f) textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentCenter]];
  
  if (distance.length) {
    
    [text addAttributes:
     @{
       NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
       } range:[fullAddress rangeOfString:distance]];
    
  }

  _restaurantInfoLabelAddress.text = text;
  [_workdayButton setTitle:_restaurant.schedules.work.fromToText forState:UIControlStateNormal];

}

@end
