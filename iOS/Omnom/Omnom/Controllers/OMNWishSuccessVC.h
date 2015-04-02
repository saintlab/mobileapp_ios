//
//  OMNBarSuccessVC.h
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNBackgroundVC.h"
#import "OMNWish.h"

@interface OMNWishSuccessVC : OMNBackgroundVC

@property (nonatomic, copy) dispatch_block_t didFinishBlock;

- (instancetype)initWithWish:(OMNWish *)wish paymentOrdersURL:(NSURL *)paymentOrdersURL;

@end
