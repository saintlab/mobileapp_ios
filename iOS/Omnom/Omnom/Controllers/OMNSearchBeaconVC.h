//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNLoadingCircleVC.h"
#import "OMNLoaderView.h"

@class OMNSearchBeaconVC;

typedef void(^OMNSearchBeaconVCBlock)(OMNSearchBeaconVC *searchBeaconVC, OMNDecodeBeacon *decodeBeacon);

@interface OMNSearchBeaconVC : OMNLoadingCircleVC

- (instancetype)initWithParent:(OMNCircleRootVC *)parent completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock;

- (void)didFailOmnom;

@end
