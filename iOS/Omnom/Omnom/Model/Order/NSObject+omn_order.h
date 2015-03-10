//
//  NSObject+omn_order.h
//  omnom
//
//  Created by tea on 10.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNOrder.h"
#import "OMNError.h"

@interface NSObject (omn_order)

- (NSArray *)omn_decodeOrdersWithError:(OMNError **)error;

@end
