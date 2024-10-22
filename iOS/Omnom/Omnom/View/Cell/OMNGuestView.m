//
//  OMNGuestView.m
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNGuestView.h"
#import <OMNStyler.h>

NSString * const OMNGuestViewIdentifier = @"OMNGuestViewIdentifier";

@implementation OMNGuestView {

  UILabel *_label;
  UIButton *_button;

}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  self = [super initWithReuseIdentifier:OMNGuestViewIdentifier];
  if (self) {
    
    _label = [[UILabel alloc] init];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.font = FuturaOSFOmnomMedium(16.0f);
    _label.textColor = [UIColor blackColor];
    [self addSubview:_label];
    
    UIView *seporatorView = [[UIView alloc] init];
    seporatorView.translatesAutoresizingMaskIntoConstraints = NO;
    seporatorView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    [self addSubview:seporatorView];
    
    _button = [[UIButton alloc] init];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_button];
    
    NSDictionary *views =
    @{
      @"label" : _label,
      @"button" : _button,
      @"seporatorView" : seporatorView,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : @(OMNStyler.leftOffset),
      };
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[button]|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[button]|" options:kNilOptions metrics:metrics views:views]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label]-(5)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[label]|" options:kNilOptions metrics:metrics views:views]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[seporatorView]-(leftOffset)-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[seporatorView(1)]|" options:kNilOptions metrics:metrics views:views]];
    
    self.backgroundView = [[UIView alloc] init];
    self.backgroundView.backgroundColor = [UIColor whiteColor];
    
  }
  return self;
}

- (void)setGuest:(OMNGuest *)guest {
  
  _guest = guest;
  _label.text = [NSString stringWithFormat:kOMN_GUEST_NUMBER_FORMAT, guest.index + 1];
  
}

@end
