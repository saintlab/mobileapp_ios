//
//  OMNPaymentNotificationControl.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentNotificationControl.h"

@interface OMNPaymentNotificationControl()

@property (nonatomic, strong, readonly) UIButton *closeButton;

@end

@implementation OMNPaymentNotificationControl {
  BOOL _constraintsUpdated;
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:2.0f/255.0f green:193.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"cross_icon_white"] forState:UIControlStateNormal];
    _closeButton.titleLabel.font = [UIFont fontWithName:@"Futura-OSF-Omnom-Regular" size:20.0f];
    _closeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _closeButton.titleLabel.minimumScaleFactor = 0.2f;
    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _closeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(removeTap) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_closeButton];
  }
  return self;
}

- (void)removeTap {
  
  [UIView animateWithDuration:0.3 animations:^{
    
    self.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [self removeFromSuperview];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];

  }];
  
}

+ (void)showWithInfo:(NSDictionary *)info {
  
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
  
  UIWindow *window = [[UIApplication sharedApplication].delegate window];
  
  OMNPaymentNotificationControl *control = [[OMNPaymentNotificationControl alloc] init];
  NSDictionary *user = info[@"user"];
  NSString *title = [NSString stringWithFormat:@"%@ Оплатил %.0fР", user[@"name"], [info[@"amount"] doubleValue]/100.];
  [control.closeButton setTitle:title forState:UIControlStateNormal];
  [window addSubview:control];
}

- (void)updateConstraints {
  [super updateConstraints];
  
  if (_constraintsUpdated) {
    return;
  }
  _constraintsUpdated = YES;
  
  NSDictionary *views =
  @{
    @"self" : self,
    @"closeButton" : _closeButton,
    };
  
  [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
  [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[closeButton]|" options:0 metrics:0 views:views]];
  [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:views]];
  [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(64.0)]" options:0 metrics:nil views:views]];
  
}

@end