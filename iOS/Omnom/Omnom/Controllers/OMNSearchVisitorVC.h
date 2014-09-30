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

@class OMNSearchVisitorVC;

typedef void(^OMNSearchBeaconVCBlock)(OMNSearchVisitorVC *searchBeaconVC, OMNVisitor *visitor);

@interface OMNSearchVisitorVC : OMNLoadingCircleVC

@property (nonatomic, strong) OMNVisitor *visitor;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent completion:(OMNSearchBeaconVCBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock;

- (void)didFailOmnom;

@end
