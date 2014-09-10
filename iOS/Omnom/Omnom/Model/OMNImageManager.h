//
//  OMNImageManager.h
//  omnom
//
//  Created by tea on 10.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNImageManager : NSObject

+ (instancetype)manager;

- (void)downloadImageWithURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionBlock;

@end
