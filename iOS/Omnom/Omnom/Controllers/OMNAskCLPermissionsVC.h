//
//  OMNAskNavigationPermissionsVC.h
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"
#import <PromiseKit.h>

@interface OMNAskCLPermissionsVC : OMNCircleRootVC

+ (PMKPromise *)askPermission:(OMNCircleRootVC *)rootV;

@end

