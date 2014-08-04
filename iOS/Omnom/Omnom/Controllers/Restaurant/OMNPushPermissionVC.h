//
//  OMNPushPermissionVC.h
//  omnom
//
//  Created by tea on 03.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@interface OMNPushPermissionVC : OMNCircleRootVC

@property (nonatomic, copy) dispatch_block_t completionBlock;

@end
