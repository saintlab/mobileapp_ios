//
//  GUserInfoTransition.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GUserInfoTransition : NSObject
<UIViewControllerAnimatedTransitioning>

+ (instancetype)forwardTransition;

+ (instancetype)backwardTransition;

@end
