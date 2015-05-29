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
#import "OMNAuthorization.h"

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
      @"leftOffset" : @(OMNStyler.leftOffset),
      };
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_closeButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(leftOffset)-[closeButton]-|" options:kNilOptions metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[closeButton]|" options:kNilOptions metrics:nil views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[self]|" options:kNilOptions metrics:nil views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self(64.0)]" options:kNilOptions metrics:nil views:views]];
    
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

+ (void)showText:(NSString *)text delay:(NSTimeInterval)delay {
 
  OMNPaymentNotificationControl *control = [[OMNPaymentNotificationControl alloc] init];
  control.alpha = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    
    control.alpha = 1.0f;
    
  }];
  
  [control.closeButton setTitle:text forState:UIControlStateNormal];
  
  [self playPaySound];
  
  __weak typeof(control)weakControl = control;
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
    [weakControl slideUp];
    
  });
  
}

+ (void)showWithPaymentDetails:(OMNPaymentDetails *)paymentDetails {
  
  if (![paymentDetails.userID isEqualToString:[OMNAuthorization authorization].user.id] &&
      0ll == paymentDetails.netAmount) {
    //don't show notificationControl for tips only payment 
    return;
  }
  
  NSString *title = nil;
  if ([paymentDetails.userID isEqualToString:[OMNAuthorization authorization].user.id] &&
      paymentDetails.tipAmount > 0) {

    if (paymentDetails.netAmount) {
      
      title = [NSString stringWithFormat:kOMN_PAYMENT_NOTIFICATION_AMOUNT_WITH_TIPS_FORMAT, paymentDetails.userName, [OMNUtils moneyStringFromKop:paymentDetails.netAmount], [OMNUtils moneyStringFromKop:paymentDetails.tipAmount]];
      
    }
    else {

      title = [NSString stringWithFormat:kOMN_PAYMENT_NOTIFICATION_TIPS_ONLY_FORMAT, paymentDetails.userName, [OMNUtils moneyStringFromKop:paymentDetails.tipAmount]];
      
    }
    
  }
  else {

    title = [NSString stringWithFormat:kOMN_PAYMENT_NOTIFICATION_AMOUNT_FORMAT, paymentDetails.userName, [OMNUtils moneyStringFromKop:paymentDetails.netAmount]];
    
  }
  
  [self showText:title delay:5.0f];
  
}

+ (void)playPaySound {
  
  static dispatch_once_t onceToken;
  static SystemSoundID paySoundID = 0;
  dispatch_once(&onceToken, ^{
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:@"pay_done" ofType:@"caf"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &paySoundID);
  });
  
  AudioServicesPlaySystemSound(paySoundID);
  
}

@end

@implementation OMNPaymentDetails

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    NSDictionary *user = jsonData[@"user"];
    self.userID = [user[@"id"] description];
    self.userName = user[@"name"];
    
    NSDictionary *transaction = jsonData[@"transaction"];
    self.totalAmount = [transaction[@"amount"] longLongValue];
    self.tipAmount = [transaction[@"tip"] longLongValue];
    
  }
  return self;
}

+ (instancetype)paymentDetailsWithTotalAmount:(long long)totalAmount tipAmount:(long long)tipAmount userID:(NSString *)userID userName:(NSString *)userName {
  
  OMNPaymentDetails *paymentDetails = [[OMNPaymentDetails alloc] init];
  paymentDetails.userID = userID;
  paymentDetails.userName = userName;
  paymentDetails.totalAmount = totalAmount;
  paymentDetails.tipAmount = tipAmount;
  return paymentDetails;
  
}

- (long long)netAmount {
  
  return self.totalAmount - self.tipAmount;
  
}

@end
