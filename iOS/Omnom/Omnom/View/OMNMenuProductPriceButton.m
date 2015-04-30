//
//  OMNMenuProductPriceButton.m
//  omnom
//
//  Created by tea on 12.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProductPriceButton.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"

#define kUIControlStateCustomState (1 << 16)

@implementation OMNMenuProductPriceButton {
  
  UIControlState _customState;
  
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    
    self.contentEdgeInsets = [OMNStyler buttonEdgeInsets];
    [self setTitleColor:[OMNStyler blueColor] forState:UIControlStateNormal];
    [self setTitleColor:colorWithHexString(@"FFFFFF") forState:UIControlStateHighlighted];
    [self setTitleColor:colorWithHexString(@"FFFFFF") forState:kUIControlStateCustomState];
    [self setTitle:@"" forState:UIControlStateSelected];
    [self setTitle:@"" forState:UIControlStateSelected|kUIControlStateCustomState];
    [self setTitle:@"" forState:UIControlStateSelected|UIControlStateHighlighted];
    UIImage *iconImage = [UIImage imageNamed:@"ic_in_wish_list_position"];
    [self setImage:iconImage forState:UIControlStateSelected];
    [self setImage:iconImage forState:UIControlStateSelected|kUIControlStateCustomState];
    [self setImage:iconImage forState:UIControlStateSelected|UIControlStateHighlighted];
    self.titleLabel.font = PRICE_BUTTON_FONT;
    [self setBackgroundImage:[[UIImage imageNamed:@"rounded_button_light_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)] forState:UIControlStateNormal];
    UIImage *selectedImage = [[UIImage imageNamed:@"blue_button_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0f, 20.0f, 0.0f, 20.0f)];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:selectedImage forState:kUIControlStateCustomState];
    [self setBackgroundImage:selectedImage forState:UIControlStateSelected|kUIControlStateCustomState];
    [self setBackgroundImage:[selectedImage omn_tintWithColor:[[OMNStyler blueColor] colorWithAlphaComponent:0.5f]] forState:UIControlStateSelected|UIControlStateHighlighted];
    
  }
  return self;
}

- (void)setOmn_editing:(BOOL)omn_editing {
  
  if (omn_editing) {
    _customState |= kUIControlStateCustomState;
  }
  else {
    _customState &= ~kUIControlStateCustomState;
  }

  [super setSelected:!self.selected];
  [super setSelected:!self.selected];
  [self stateWasUpdated];
  
}

- (UIControlState)state {
  
  return [super state] | _customState;
  
}

- (void)setSelected:(BOOL)newSelected {
  
  [super setSelected:newSelected];
  [self stateWasUpdated];
  
}

- (void)setHighlighted:(BOOL)newHighlighted {
  
  [super setHighlighted:newHighlighted];
  [self stateWasUpdated];
  
}

- (void)setEnabled:(BOOL)newEnabled {
  
  [super setEnabled:newEnabled];
  [self stateWasUpdated];
  
}

- (void)stateWasUpdated {
  // Add your custom code here to respond to the change in state
}


@end
