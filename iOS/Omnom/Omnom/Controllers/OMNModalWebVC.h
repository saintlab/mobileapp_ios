//
//  OMNModalWebVC.h
//  omnom
//
//  Created by tea on 16.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNModalWebVC : UIViewController

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;

@end
