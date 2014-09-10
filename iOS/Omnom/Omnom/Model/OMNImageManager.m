//
//  OMNImageManager.m
//  omnom
//
//  Created by tea on 10.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNImageManager.h"
#import <SDWebImageManager.h>

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

- (void)downloadImageWithURL:(NSString *)urlString completion:(void (^)(UIImage *image))completionBlock {
  
  NSURL *imageUrl = [NSURL URLWithString:urlString];
  
  if ([_imageManager cachedImageExistsForURL:imageUrl]) {

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:imageUrl];
    [request setHTTPMethod:@"HEAD"];
    request.timeoutInterval = 5.0;
    __weak typeof(self)weakSelf = self;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
      
      SDWebImageOptions options = 0;
      if ([response expectedContentLength] != [weakSelf cachedImageSizeForUrl:imageUrl]) {
        options = SDWebImageRefreshCached;
      }
      [weakSelf startDownloadImageWithURL:imageUrl options:options completion:completionBlock];
      
    }];

  }
  else {
    
    [self startDownloadImageWithURL:imageUrl options:0 completion:completionBlock];
    
  }

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
