//
//  OMNRestaurantCardButtonsView.m
//  omnom
//
//  Created by tea on 14.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNRestaurantCardButtonsView.h"
#import "UIView+omn_autolayout.h"
#import <OMNStyler.h>

@implementation OMNRestaurantCardButtonsView

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self omn_setup];
    
  }
  return self;
}

- (void)omn_setup {
  
  NSMutableArray *buttons = [NSMutableArray array];
  UIColor *defaultColor = [OMNStyler blueColor];
  UIColor *disabledColor = colorWithHexString(@"A1A1A1");
  
  
  OMNRestaurantSettings *settings = _restaurant.settings;
  if (settings.has_bar) {
    
    _barButton = [OMNBottomTextButton omn_autolayoutView];
    [_barButton setTitle:kOMN_RESTAURANT_MODE_BAR_TITLE image:[UIImage imageNamed:@"card_ic_bar"] highlightedImage:[UIImage imageNamed:@"card_ic_bar_selected"] color:defaultColor disabledColor:disabledColor];
    [buttons addObject:_barButton];
  }
  
  if (settings.has_table_order) {
    
    _onTableButton = [OMNBottomTextButton omn_autolayoutView];
    [_onTableButton setTitle:kOMN_RESTAURANT_MODE_TABLE_TITLE image:[UIImage imageNamed:@"card_ic_table"] highlightedImage:[UIImage imageNamed:@"card_ic_table_selected"] color:defaultColor disabledColor:disabledColor];
    [buttons addObject:_onTableButton];
    
  }
  
  if (settings.has_restaurant_order) {
    
    _inRestaurantButton = [OMNBottomTextButton omn_autolayoutView];
    [_inRestaurantButton setTitle:kOMN_RESTAURANT_MODE_RESTAURANT_TITLE image:[UIImage imageNamed:@"card_ic_table"] highlightedImage:[UIImage imageNamed:@"card_ic_table_selected"] color:defaultColor disabledColor:disabledColor];
    [buttons addObject:_inRestaurantButton];
    
  }
  
  if (settings.has_lunch) {
    
    _lunchButton = [OMNBottomTextButton omn_autolayoutView];
    [_lunchButton setTitle:kOMN_RESTAURANT_MODE_LUNCH_TITLE image:[UIImage imageNamed:@"card_ic_order"] highlightedImage:[UIImage imageNamed:@"card_ic_order_selected"] color:defaultColor disabledColor:disabledColor];
    [buttons addObject:_lunchButton];
    
  }
  
  if (settings.has_pre_order) {
    
    _preorderButton = [OMNBottomTextButton omn_autolayoutView];
    [_preorderButton setTitle:kOMN_RESTAURANT_MODE_TAKE_AWAY_TITLE image:[UIImage imageNamed:@"card_ic_takeaway"] highlightedImage:[UIImage imageNamed:@"card_ic_takeaway_selected"] color:defaultColor disabledColor:disabledColor];
    [buttons addObject:_preorderButton];
    
  }
  
  NSMutableDictionary *buttonViews = [NSMutableDictionary dictionary];
  UIView *fillView = [UIView omn_autolayoutView];
  [self addSubview:fillView];
  buttonViews[@"v0"] = fillView;
  NSMutableString *format = [NSMutableString stringWithString:@"H:|[v0(>=0)]"];
  
  [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
    
    NSString *buttonName = [NSString stringWithFormat:@"b%lu", (unsigned long)idx];
    buttonViews[buttonName] = button;
    [format appendFormat:@"[%@]", buttonName];
    
    NSString *fillViewName = [NSString stringWithFormat:@"v%lu", (unsigned long)idx + 1];
    UIView *fillView = [UIView omn_autolayoutView];
    [self addSubview:fillView];
    buttonViews[fillViewName] = fillView;
    
    [format appendFormat:@"[%@(==v0)]", fillViewName];
    
    [self addSubview:button];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[%@]|", buttonName] options:kNilOptions metrics:nil views:buttonViews]];
    
  }];
  
  [format appendString:@"|"];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:nil views:buttonViews]];
  
}

@end
