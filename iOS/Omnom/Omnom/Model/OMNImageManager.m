//
//  OMNImageManager.m
//  omnom
//
//  Created by tea on 10.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNImageManager.h"
#import <SDWebImageManager.h>
#import "UIImage+ImageEffects.h"

@interface OMNImageManager ()
<SDWebImageManagerDelegate>

@end

@implementation OMNImageManager {
  SDWebImageManager *_imageManager;
}

+ (instancetype)manager {
  static id manager = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[[self class] alloc] init];
  });
  return manager;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    _imageManager = [[SDWebImageManager alloc] init];
    _imageManager.imageCache.maxCacheAge = 30 * 24 * 60 * 60;
    _imageManager.imageCache.maxCacheSize = 1024 * 1024 * 10;
    _imageManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
    
  }
  return self;
}

- (void)removeImageForUrl:(NSURL *)url {
  [_imageManager.imageCache removeImageForKey:[_imageManager cacheKeyForURL:url]];
}

- (UIImage *)cachedImageForURL:(NSString *)urlString {
  
  NSString *key = [_imageManager cacheKeyForURL:[NSURL URLWithString:urlString]];
  return [_imageManager.imageCache imageFromDiskCacheForKey:key];
  
}

- (void)downloadImageWithURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionBlock {
  
  NSURL *imageUrl = [NSURL URLWithString:urlString];
  [self startDownloadImageWithURL:imageUrl options:0 completion:completionBlock];

}

- (void)downloadBlurredImageWithURL:(NSString *)urlString expectedSize:(CGSize)expectedSize completion:(void (^)(UIImage *image))completionBlock {
  
  NSURL *smallImageUrl = [NSURL URLWithString:[urlString stringByAppendingString:@"?w=50"]];
  
  [self startDownloadImageWithURL:smallImageUrl options:SDWebImageRetryFailed completion:^(UIImage *image) {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      
      CGRect drawFrame = (CGRect){CGPointZero, expectedSize};
      UIGraphicsBeginImageContextWithOptions(expectedSize, YES, 0.0);
      [image drawInRect:drawFrame];
      UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      UIImage *finalImage = [scaledImage omn_applyLightEffect];

      dispatch_async(dispatch_get_main_queue(), ^{
        completionBlock(finalImage);
      });
    
    });
    
  }];
  
}

- (void)getImageSizeWithURL:(NSURL *)url comletionBlock:(void (^)(long long size))comletionBlock {
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request setHTTPMethod:@"HEAD"];
  request.timeoutInterval = 5.0;
  [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    
    comletionBlock([response expectedContentLength]);
    
  }];
  
}

- (void)startDownloadImageWithURL:(NSURL *)imageUrl options:(SDWebImageOptions)options completion:(void (^)(UIImage *image))completionBlock {
  
  [_imageManager downloadImageWithURL:imageUrl options:options progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
    
    if (image.scale != 2.0f) {
      image = [UIImage imageWithCGImage:image.CGImage scale:2.0f orientation:image.imageOrientation];
    }
    completionBlock(image);
    
  }];
  
}

- (long long)cachedImageSizeForUrl:(NSURL *)imageUrl {

  if (NO == [_imageManager cachedImageExistsForURL:imageUrl]) {
    return 0ul;
  }
  
  NSString *key = [_imageManager cacheKeyForURL:imageUrl];
  NSString *imageDataPath = [_imageManager.imageCache defaultCachePathForKey:key];
  NSURL *fileURL = [NSURL fileURLWithPath:imageDataPath];
  NSNumber *fileSize = nil;
  [fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL];
  return [fileSize longLongValue];
  
}

@end
