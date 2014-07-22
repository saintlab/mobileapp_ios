//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNSearchBeaconRootVC.h"

typedef void(^OMNSearchBeaconVCBlock)(OMNDecodeBeacon *decodeBeacon);

@interface OMNSearchBeaconVC : OMNSearchBeaconRootVC

- (instancetype)initWithBlock:(OMNSearchBeaconVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock;

@end
