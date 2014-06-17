//
//  GAddCardVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNPayCardVCDelegate;
@class OMNCardInfo;

@interface OMNPayCardVC : UIViewController

@property (nonatomic, weak) id<OMNPayCardVCDelegate> delegate;

@end

@protocol OMNPayCardVCDelegate <NSObject>

- (void)payCardVC:(OMNPayCardVC *)payVC requestPayWithCardInfo:(OMNCardInfo *)cardInfo;

- (void)payCardVCDidPayCash:(OMNPayCardVC *)payVC;

@end
