//
//  OMNSuncityPreorderDoneVC.h
//  omnom
//
//  Created by tea on 01.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNPreorderDoneVC.h"
#import "OMNWish.h"

@interface OMNSuncityPreorderDoneVC : OMNPreorderDoneVC

- (instancetype)initWithWish:(OMNWish *)wish didCloseBlock:(dispatch_block_t)didCloseBlock;

@end
