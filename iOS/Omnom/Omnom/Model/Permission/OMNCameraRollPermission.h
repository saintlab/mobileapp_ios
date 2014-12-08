//
//  OMNCameraRollPermission.h
//  omnom
//
//  Created by tea on 05.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNCameraRollPermission : NSObject

+ (void)requestPermission:(dispatch_block_t)authorizedBlock restricted:(dispatch_block_t)restrictedBlock;
+ (BOOL)didReceiveCameraPermission;

@end
