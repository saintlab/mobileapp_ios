//
//  OMNScanQRCodeVC.h
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OMNScanQRCodeVCDelegate;

@interface OMNScanQRCodeVC : UIViewController

@property (nonatomic, weak) id<OMNScanQRCodeVCDelegate> delegate;

- (void)stopScanning;

@end

@protocol OMNScanQRCodeVCDelegate <NSObject>

- (void)scanQRCodeVC:(OMNScanQRCodeVC *)scanQRCodeVC didScanCode:(NSString *)code;

- (void)scanQRCodeVCDidCancel:(OMNScanQRCodeVC *)scanQRCodeVC;

@end