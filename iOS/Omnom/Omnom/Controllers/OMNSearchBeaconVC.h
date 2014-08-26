//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor.h"
#import "OMNLoadingCircleVC.h"
#import "OMNLoaderView.h"

@class OMNSearchBeaconVC;

typedef void(^OMNSearchBeaconVCBlock)(OMNSearchBeaconVC *searchBeaconVC, OMNVisitor *decodeBeacon);

@interface OMNSearchBeaconVC : OMNLoadingCircleVC

@property (nonatomic, strong) OMNVisitor *decodeBeacon;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock;

- (void)didFailOmnom;

@end
