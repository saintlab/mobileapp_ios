//
//  GUserInfoTransitionDelegate.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNUserInfoTransitionDelegate : NSObject
<UIViewControllerTransitioningDelegate>

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

@end
