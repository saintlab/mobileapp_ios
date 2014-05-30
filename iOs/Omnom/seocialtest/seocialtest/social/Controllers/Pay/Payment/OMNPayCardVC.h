//
//  GAddCardVC.h
//  seocialtest
//
//  Created by tea on 13.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNPayCardVCDelegate;
@class GCardInfo;

@interface OMNPayCardVC : UIViewController

@property (nonatomic, weak) id<OMNPayCardVCDelegate> delegate;

@end

@protocol OMNPayCardVCDelegate <NSObject>

- (void)payVC:(OMNPayCardVC *)payVC requestPayWithCardInfo:(GCardInfo *)cardInfo;

- (void)payVCDidPayCash:(OMNPayCardVC *)payVC;

@end
