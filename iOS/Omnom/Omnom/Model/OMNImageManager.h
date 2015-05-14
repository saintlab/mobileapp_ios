//
//  OMNImageManager.h
//  omnom
//
//  Created by tea on 10.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SDWebImageManager.h>

@interface OMNImageManager : NSObject

+ (instancetype)manager;

- (void)downloadImageWithURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionBlock;
- (id<SDWebImageOperation>)downloadImageWithURL:(NSString *)urlString progress:(void (^)(CGFloat progress))progressBlock completion:(void (^)(UIImage *image))completionBlock;
- (void)downloadImageWithURL:(NSString *)imageUrl numberOfRetries:(NSInteger)numberOfRetries completion:(void (^)(UIImage *image))completionBlock;
- (void)downloadBlurredImageWithURL:(NSString *)urlString expectedSize:(CGSize)expectedSize completion:(void (^)(UIImage *image))completionBlock;
- (UIImage *)cachedImageForURL:(NSString *)urlString;

@end
