//
//  OMNAskNavigationPermissionsVC.h
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@interface OMNAskCLPermissionsVC : OMNCircleRootVC

@property (nonatomic, copy) dispatch_block_t didReceivePermissionBlock;

@end

