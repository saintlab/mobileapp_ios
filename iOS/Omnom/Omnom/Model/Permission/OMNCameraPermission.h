//
//  OMNCameraPermission.h
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNCameraPermission : NSObject

+ (void)requestPermission:(dispatch_block_t)authorizedBlock restricted:(dispatch_block_t)restrictedBlock;
+ (BOOL)didReceiveCameraPermission;

@end
