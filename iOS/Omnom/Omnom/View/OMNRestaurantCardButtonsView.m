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
#import "OMNVisitorFactory.h"

@implementation OMNRestaurantCardButtonsView {
  
  NSArray *_visitors;
  
}

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant {
  self = [super init];
  if (self) {
    
    _restaurant = restaurant;
    _visitors = [OMNVisitorFactory visitorsForRestaurant:_restaurant];
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self omn_setup];
    
  }
  return self;
}

- (void)buttonTap:(UIControl *)control {
  
  OMNVisitor *selectedVisitor = _visitors[control.tag];
  [self.delegate cardButtonsView:self didSelectVisitor:selectedVisitor];
  
}

- (void)omn_setup {
  
  NSMutableArray *buttons = [NSMutableArray array];
  [_visitors enumerateObjectsUsingBlock:^(OMNVisitor *visitor, NSUInteger idx, BOOL *stop) {
    
    OMNBottomTextButton *button = [OMNBottomTextButton omn_autolayoutView];
    NSString *imageName = visitor.restarantCardButtonIcon;
    NSString *selectedImageName = [visitor.restarantCardButtonIcon stringByAppendingString:@"_selected"];
    [button setTitle:visitor.restarantCardButtonTitle image:[UIImage imageNamed:imageName] highlightedImage:[UIImage imageNamed:selectedImageName] color:[OMNStyler blueColor] disabledColor:colorWithHexString(@"A1A1A1")];
    button.tag = idx;
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];

  }];
   
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
