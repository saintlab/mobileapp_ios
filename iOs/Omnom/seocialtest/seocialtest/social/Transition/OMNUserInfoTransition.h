//
//  GUserInfoTransition.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNUserInfoTransition : NSObject
<UIViewControllerAnimatedTransitioning>

+ (instancetype)forwardTransitionWithComplition:(dispatch_block_t)complitionBlock;

+ (instancetype)backwardTransition;

@end
