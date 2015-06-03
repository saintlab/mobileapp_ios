//
//  OMNProductModiferAlertVC.h
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNMenuProduct.h"
#import <PromiseKit.h>

@interface OMNProductModiferAlertVC : OMNModalAlertVC

- (instancetype)initWithMenuProduct:(OMNMenuProduct *)menuProduct;
+ (PMKPromise *)editProduct:(OMNMenuProduct *)menuProduct fromRootVC:(UIViewController *)rootVC;

@end
