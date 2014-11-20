//
//  OMNPaymentLoadingVC.h
//  omnom
//
//  Created by tea on 20.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoadingCircleVC.h"

@interface OMNPaymentLoadingVC : OMNLoadingCircleVC

- (void)didFailWithError:(NSError *)error action:(dispatch_block_t)actionBlock;
- (void)startLoading;

@end
