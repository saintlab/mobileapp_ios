//
//  OMNCircleAnimation.h
//  omnom
//
//  Created by tea on 29.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNCircleAnimation : NSObject

- (instancetype)initWithCircleButton:(UIButton *)circleButton;

- (void)beginCircleAnimationIfNeededWithImage:(UIImage *)image;
- (void)finishCircleAnimation;

@end
