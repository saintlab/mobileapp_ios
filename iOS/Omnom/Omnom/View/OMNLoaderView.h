//
//  OMNLoaderView.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNLoaderView : UIView

- (instancetype)initWithInnerFrame:(CGRect)frame;

- (void)setLoaderColor:(UIColor *)color;
- (void)startAnimating:(NSTimeInterval)duration;
- (void)completeAnimation:(dispatch_block_t)complitionBlock;
- (void)setProgress:(CGFloat)progress;
- (void)stop;


@end
