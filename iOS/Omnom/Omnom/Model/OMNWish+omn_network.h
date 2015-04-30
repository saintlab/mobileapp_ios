//
//  OMNWish+omn_network.h
//  omnom
//
//  Created by tea on 30.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWish.h"
#import <PromiseKit.h>

@interface OMNWish (omn_network)

+ (PMKPromise *)wishWithID:(NSString *)wishID;

@end
