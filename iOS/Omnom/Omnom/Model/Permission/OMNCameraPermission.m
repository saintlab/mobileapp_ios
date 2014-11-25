//
//  OMNCameraPermission.m
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCameraPermission.h"
#import <AVFoundation/AVFoundation.h>

@implementation OMNCameraPermission

+ (void)requestPermission:(dispatch_block_t)authorizedBlock restricted:(dispatch_block_t)restrictedBlock {
  
  NSString *mediaType = AVMediaTypeVideo;
  AVAuthorizationStatus authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
  
  switch (authorizationStatus) {
    case AVAuthorizationStatusNotDetermined:{
      
      [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
          
          if (granted) {
            
            authorizedBlock();
            
          }
          else {
            
            restrictedBlock();
            
          }
        
        });
        
      }];
      
    } break;
    case AVAuthorizationStatusRestricted: {
      
      restrictedBlock();
      
    } break;
    case AVAuthorizationStatusDenied: {
      
      restrictedBlock();
      
    } break;
    case AVAuthorizationStatusAuthorized: {
      
      authorizedBlock();
      
    } break;
    default: {
      
      authorizedBlock();
      
    } break;
  }
  
}

+ (BOOL)didReceiveCameraPermission {
  
  return (AVAuthorizationStatusAuthorized == [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]);

}

@end
