//
//  OMNCustomTransition.h
//  restaurants
//
//  Created by tea on 03.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNCustomTransition : NSObject
<UIViewControllerAnimatedTransitioning>

+ (NSString *)key;
+ (NSString *)keyFromClass:(Class)fromClass toClass:(Class)toClass;

@end
