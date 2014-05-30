//
//  OMNSearchTableVC.h
//  restaurants
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDecodeBeacon.h"

typedef void(^OMNSearchTableVCBlock)(OMNDecodeBeacon *decodeBeacon);

@interface OMNSearchTableVC : UIViewController

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block;

@end
