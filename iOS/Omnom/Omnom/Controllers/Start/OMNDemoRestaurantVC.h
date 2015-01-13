//
//  OMNDemoRestaurantVC.h
//  omnom
//
//  Created by tea on 18.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"
#import "OMNError.h"

@interface OMNDemoRestaurantVC : OMNLoadingCircleVC

@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end

