//
//  OMNTransitionFromListToProduct.h
//  restaurants
//
//  Created by tea on 01.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStubProductCell.h"

@interface OMNTransitionFromListToProduct : NSObject
<UIViewControllerAnimatedTransitioning>

- (instancetype)initWithCell:(OMNStubProductCell *)cell;

@end
