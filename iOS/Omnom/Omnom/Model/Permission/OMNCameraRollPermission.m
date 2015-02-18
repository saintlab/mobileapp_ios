//
//  OMNCameraRollPermission.m
//  omnom
//
//  Created by tea on 05.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraRollPermission.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation OMNCameraRollPermission

+ (void)requestPermission:(dispatch_block_t)authorizedBlock restricted:(dispatch_block_t)restrictedBlock {
  
  if ([self didReceiveCameraPermission]) {
    authorizedBlock();
    return;
  }
  
  ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
  [lib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
    
    authorizedBlock();
    *stop = YES;
    
  } failureBlock:^(NSError *error) {
    
    restrictedBlock();
    
  }];
  
}

+ (BOOL)didReceiveCameraPermission {
  
  return (ALAuthorizationStatusAuthorized == [ALAssetsLibrary authorizationStatus]);
  
}

@end
