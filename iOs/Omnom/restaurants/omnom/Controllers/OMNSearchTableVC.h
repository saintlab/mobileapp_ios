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

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (instancetype)initWithBlock:(OMNSearchTableVCBlock)block cancelBlock:(dispatch_block_t)cancelBlock;

@end
