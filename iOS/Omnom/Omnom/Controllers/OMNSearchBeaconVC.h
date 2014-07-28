//
//  OMNSearchBeaconVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"
#import "OMNSearchBeaconRootVC.h"
#import "OMNLoaderView.h"

typedef void(^OMNSearchBeaconVCBlock)(OMNDecodeBeacon *decodeBeacon);

@interface OMNSearchBeaconVC : OMNSearchBeaconRootVC

@property (nonatomic, strong, readonly) OMNLoaderView *loaderView;
@property (nonatomic, assign) NSTimeInterval estimateSearchDuration;
@property (nonatomic, strong) UIImage *backgroundImage;

- (instancetype)initWithBlock:(OMNSearchBeaconVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock;

- (void)setLogo:(UIImage *)logo withColor:(UIColor *)color completion:(dispatch_block_t)completionBlock;

@end
