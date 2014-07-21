//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNSearchBeaconRootVC.h"

@interface OMNSearchBeaconVC : OMNSearchBeaconRootVC

@end

@protocol OMNSearchBeaconVCDelegate <NSObject>

- (void)searchBeaconVC:(OMNSearchBeaconVC *)searchBeaconVC didFindBeacon:(OMNDecodeBeacon *)decodeBeacon;

- (void)searchBeaconVCDidCancel:(OMNSearchBeaconVC *)searchBeaconVC;

@end