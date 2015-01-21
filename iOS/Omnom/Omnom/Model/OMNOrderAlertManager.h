//
//  OMNOrderAlertManager.h
//  omnom
//
//  Created by tea on 21.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNOrder.h"

@interface OMNOrderAlertManager : NSObject

@property (nonatomic, strong) OMNOrder *order;
@property (nonatomic, copy) dispatch_block_t didCloseBlock;
@property (nonatomic, copy) dispatch_block_t didUpdateBlock;

+ (instancetype)sharedManager;

- (void)checkOrderIsClosed;

@end
