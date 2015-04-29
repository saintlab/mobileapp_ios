//
//  OMNMyOrderButton.m
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMyOrderButton.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"
#import "OMNUtils.h"

@implementation OMNMyOrderButton {
  
  OMNRestaurantMediator *_restaurantMediator;
  
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)initWithRestaurantMediator:(OMNRestaurantMediator *)restaurantMediator {
  self = [super init];
  if (self) {
    
    _restaurantMediator = restaurantMediator;
    
    UIColor *textColor = [UIColor colorWithWhite:0.0f alpha:0.4f];
    self.contentEdgeInsets = UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f);
    [self setTitleColor:textColor forState:UIControlStateNormal];
    [self setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateHighlighted];
    [self setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateSelected];
    [self setTitleColor:[colorWithHexString(@"FFFFFF") colorWithAlphaComponent:0.5f] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self setTitle:kOMN_MY_ORDER_BUTTON_TITLE forState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setTitle:@"" forState:UIControlStateSelected|UIControlStateHighlighted];
    
    self.titleLabel.font = PRICE_BUTTON_FONT;
    [self setBackgroundImage:[[[UIImage imageNamed:@"rounded_button_light_bg"] omn_tintWithColor:textColor] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
    UIImage *selectedImage = [[UIImage imageNamed:@"blue_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:[selectedImage omn_tintWithColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f]] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self updateTitle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuProductDidChange:) name:OMNMenuProductDidChangeNotification object:nil];
    
    [self addTarget:_restaurantMediator action:@selector(showPreorders) forControlEvents:UIControlEventTouchUpInside];
    
  }
  return self;
}

- (void)menuProductDidChange:(NSNotification *)n {
  
  [self updateTitle];
  
}

- (void)updateTitle {
  
  OMNMenu *menu = _restaurantMediator.menu;
  self.selected = menu.hasPreorderedItems;
  NSString *title = [OMNUtils moneyStringFromKop:menu.preorderedItemsTotal];
  [self setTitle:title forState:UIControlStateSelected];
  [self setTitle:title forState:UIControlStateSelected|UIControlStateHighlighted];
  [self sizeToFit];
  
}

@end
