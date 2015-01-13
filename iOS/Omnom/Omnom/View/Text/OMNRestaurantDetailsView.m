//
//  OMNRestaurantDetailsView.m
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNRestaurantDetailsView.h"
#import "OMNConstants.h"
#import <OMNStyler.h>
#import "UIButton+omn_helper.h"
#import "OMNUtils.h"
#import "UIView+omn_autolayout.h"

@implementation OMNRestaurantDetailsView {
  
  UIButton *_workdayButton;
  UILabel *_restaurantInfoLabelAddress;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [self setup];
    
  }
  return self;
}

- (void)setup {
  
  _restaurantInfoLabelAddress = [UILabel omn_autolayoutView];
  _restaurantInfoLabelAddress.numberOfLines = 1;
  _restaurantInfoLabelAddress.textAlignment = NSTextAlignmentCenter;
  _restaurantInfoLabelAddress.font = FuturaOSFOmnomRegular(18.0f);
  _restaurantInfoLabelAddress.adjustsFontSizeToFitWidth = YES;
  _restaurantInfoLabelAddress.textColor = colorWithHexString(@"000000");
  [self addSubview:_restaurantInfoLabelAddress];
  
  _workdayButton = [UIButton omn_autolayoutView];
  _workdayButton.userInteractionEnabled = NO;
  [_workdayButton omn_centerButtonAndImageWithSpacing:8.0f];
  _workdayButton.titleLabel.font = FuturaOSFOmnomRegular(18.0f);
  [_workdayButton setTitleColor:colorWithHexString(@"000000") forState:UIControlStateNormal];
  [_workdayButton setImage:[UIImage imageNamed:@"clock_icon"] forState:UIControlStateNormal];
  [self addSubview:_workdayButton];
  
  NSDictionary *views =
  @{
    @"restaurantInfoLabelAddress" : _restaurantInfoLabelAddress,
    @"workdayButton" : _workdayButton,
    };
  
  NSDictionary *metrics =
  @{
    @"leftOffset" : [OMNStyler styler].leftOffset,
    };
  
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[restaurantInfoLabelAddress]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[workdayButton]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[restaurantInfoLabelAddress]-[workdayButton]|" options:kNilOptions metrics:metrics views:views]];
  
}

- (void)setRestaurant:(OMNRestaurant *)restaurant {
  
  _restaurant = restaurant;
  
  NSMutableString *address = [NSMutableString stringWithString:_restaurant.address.text];
  NSString *distance = @"";
  if (fabs(restaurant.distance) > 1000) {
  
    distance = [NSString stringWithFormat:@" ~%.2fкм", restaurant.distance/1000.0];
    
  }
  else {
    
    distance = [NSString stringWithFormat:@" ~%.0fм", restaurant.distance];
    
  }
  
  [address appendString:distance];
  
  
  
  NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:address attributes:[OMNUtils textAttributesWithFont:FuturaOSFOmnomRegular(18.0f) textColor:colorWithHexString(@"000000") textAlignment:NSTextAlignmentCenter]];
  
  if (distance.length) {
    
    [text addAttributes:
     @{
       NSForegroundColorAttributeName : [colorWithHexString(@"000000") colorWithAlphaComponent:0.5f],
       } range:[address rangeOfString:distance]];
    
  }

  _restaurantInfoLabelAddress.attributedText = text;
  [_workdayButton setTitle:_restaurant.schedules.work.fromToText forState:UIControlStateNormal];

}

@end
