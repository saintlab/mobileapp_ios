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

@class OMNSearchRestaurantsVC;

typedef void(^OMNSearchRestaurantsBlock)(OMNSearchRestaurantsVC *searchBeaconVC, NSArray *restaurants);

@interface OMNSearchRestaurantsVC : OMNLoadingCircleVC

@property (nonatomic, strong) OMNVisitor *visitor;
@property (nonatomic, copy) NSString *qr;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent completion:(OMNSearchRestaurantsBlock)completionBlock cancelBlock:(dispatch_block_t)cancelBlock;

@end
