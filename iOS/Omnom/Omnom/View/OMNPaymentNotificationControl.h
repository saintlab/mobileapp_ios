//
//  OMNPaymentNotificationControl.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNPaymentDetails : NSObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, assign) long long totalAmount;
@property (nonatomic, assign) long long tipAmount;
@property (nonatomic, assign, readonly) long long netAmount;

- (instancetype)initWithJsonData:(id)jsonData;
+ (instancetype)paymentDetailsWithTotalAmount:(long long)totalAmount tipAmount:(long long)tipAmount userID:(NSString *)userID userName:(NSString *)userName;

@end

@interface OMNPaymentNotificationControl : UIView

+ (void)showWithPaymentDetails:(OMNPaymentDetails *)paymentDetails;
+ (void)playPaySound;

@end
