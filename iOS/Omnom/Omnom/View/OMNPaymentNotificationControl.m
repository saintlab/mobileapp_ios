//
//  OMNPaymentNotificationControl.m
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPaymentNotificationControl.h"
#import "OMNUtils.h"
#import <AudioToolbox/AudioToolbox.h>
#import <OMNStyler.h>
#import "OMNAuthorisation.h"

@interface OMNPaymentNotificationControl()

@property (nonatomic, strong, readonly) UIButton *closeButton;

@end

@implementation OMNPaymentNotificationControl {
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:2.0f/255.0f green:193.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
    self.userInteractionEnabled = YES;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    [window addSubview:self];
    
    _closeButton = [[UIButton alloc] init];
    [_closeButton setImage:[UIImage imageNamed:@"cross_icon_white"] forState:UIControlStateNormal];
    _closeButton.titleLabel.font = FuturaLSFOmnomLERegular(20.0f);
    _closeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    _closeButton.titleLabel.minimumScaleFactor = 0.2f;
    _closeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _closeButton.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 15.0f, 0.0f, 0.0f);
    [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_closeButton addTarget:self action:@selector(removeTap) forControlEvents:UIControlEventTouchUpInside];
    _closeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_closeButton];
    
    NSDictionary *views =
    @{
      @"self" : self,
      @"closeButton" : _closeButton,
      };
    
    NSDictionary *metrics =
    @{
      @"leftOffset" : [[OMNStyler styler] leftOffset],
      };
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[closeButton]-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeButton]|" options:0 metrics:0 views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:0 metrics:nil views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(64.0)]" options:0 metrics:nil views:views]];
    
  }
  return self;
}

- (void)removeTap {
  
  [UIView animateWithDuration:0.3 animations:^{
    
    self.alpha = 0.0f;
    
  } completion:^(BOOL finished) {
    
    [self removeFromSuperview];

  }];
  
}

- (void)slideUp {
  
  [UIView animateWithDuration:0.3 animations:^{
    
    self.transform = CGAffineTransformMakeTranslation(0.0f, -CGRectGetHeight(self.frame));
    
  } completion:^(BOOL finished) {
    
    [self removeFromSuperview];
    
  }];
  
}

+ (void)showWithPaymentData:(NSDictionary *)paymentData {
  
  OMNPaymentNotificationControl *control = [[OMNPaymentNotificationControl alloc] init];
  
  control.alpha = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    
    control.alpha = 1.0f;
    
  }];
  
  NSDictionary *user = paymentData[@"user"];
  NSDictionary *transaction = paymentData[@"transaction"];
  
  long long totalAmount = [transaction[@"amount"] longLongValue];
  long long tipAmount = [transaction[@"tip"] longLongValue];
  long long netAmount = totalAmount - tipAmount;
  
  NSString *title = @"";
  NSString *userID = [user[@"id"] description];
  
  if ([userID isEqualToString:[OMNAuthorisation authorisation].user.id] &&
      tipAmount > 0) {
    
    title = [NSString stringWithFormat:NSLocalizedString(@"%@: оплачено по счету %@ + чай %@", nil), user[@"name"], [OMNUtils moneyStringFromKop:netAmount], [OMNUtils moneyStringFromKop:tipAmount]];
    
  }
  else {
    
    title = [NSString stringWithFormat:NSLocalizedString(@"%@: оплачено по счету %@", nil), user[@"name"], [OMNUtils moneyStringFromKop:netAmount]];
    
  }
  [control.closeButton setTitle:title forState:UIControlStateNormal];
  
  [self playPaySound];

  __weak typeof(control)weakControl = control;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [weakControl slideUp];
    
  });
  
}

+ (void)playPaySound {
  static SystemSoundID paySoundID = 0;
  if (0 == paySoundID) {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pay_done" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &paySoundID);
  }
  AudioServicesPlaySystemSound(paySoundID);
}

@end
