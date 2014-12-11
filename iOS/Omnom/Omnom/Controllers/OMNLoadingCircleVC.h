//
//  OMNLoadingCircleVC.h
//  omnom
//
//  Created by tea on 11.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"
#import "OMNLoaderView.h"
#import "OMNError.h"

@interface OMNLoadingCircleVC : OMNCircleRootVC

@property (nonatomic, strong, readonly) OMNLoaderView *loaderView;
@property (nonatomic, assign) NSTimeInterval estimateAnimationDuration;

- (void)setLogo:(UIImage *)logo withColor:(UIColor *)color completion:(dispatch_block_t)completionBlock;
- (void)finishLoading:(dispatch_block_t)completionBlock;
- (void)showRetryMessageWithError:(OMNError *)error retryBlock:(dispatch_block_t)retryBlock cancelBlock:(dispatch_block_t)cancelBlock;

@end
