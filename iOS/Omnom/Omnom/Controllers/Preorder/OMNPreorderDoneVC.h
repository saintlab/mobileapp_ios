//
//  OMNPreorderDoneVC.h
//  omnom
//
//  Created by tea on 19.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNPreorderDoneVC : OMNBackgroundVC

- (instancetype)initTitle:(NSString *)title subTitle:(NSString *)subTitle didCloseBlock:(dispatch_block_t)didCloseBlock;

@end
