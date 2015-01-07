//
//  OMNScanTableQRCodeVC.h
//  omnom
//
//  Created by tea on 04.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNScanQRCodeVC.h"
#import "OMNRestaurant.h"

@protocol OMNScanTableQRCodeVCDelegate;

@interface OMNScanTableQRCodeVC : OMNScanQRCodeVC

@property (nonatomic, weak) id<OMNScanTableQRCodeVCDelegate> tableDelegate;

@end

@protocol OMNScanTableQRCodeVCDelegate <NSObject>

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant;
- (void)scanTableQRCodeVCDidCancel:(OMNScanTableQRCodeVC *)scanTableQRCodeVC;

@end
