//
//  OMNScanTableQRCodeVC.h
//  omnom
//
//  Created by tea on 04.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurant.h"
#import "OMNBackgroundVC.h"

@protocol OMNScanTableQRCodeVCDelegate;

@interface OMNScanTableQRCodeVC : OMNBackgroundVC

@property (nonatomic, weak) id<OMNScanTableQRCodeVCDelegate> delegate;

@end

@protocol OMNScanTableQRCodeVCDelegate <NSObject>

- (void)scanTableQRCodeVC:(OMNScanTableQRCodeVC *)scanTableQRCodeVC didFindRestaurant:(OMNRestaurant *)restaurant;
- (void)scanTableQRCodeVCDidCancel:(OMNScanTableQRCodeVC *)scanTableQRCodeVC;

@end
