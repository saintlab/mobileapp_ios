//
//  UIImage+omn_network.m
//  omnom
//
//  Created by tea on 27.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "UIImage+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNError.h"

@implementation UIImage (omn_network)

- (PMKPromise *)omn_upload {
  
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    NSString *path = @"/images/upload";
    [[OMNOperationManager sharedManager] POST:path parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
      
      [formData appendPartWithFileData:UIImageJPEGRepresentation(self, 0.9f) name:@"image" fileName:@"image.jpeg" mimeType:@"image/jpeg"];
      
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      fulfill(responseObject[@"secure_url"]);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];
    
  }];
  
}

@end
