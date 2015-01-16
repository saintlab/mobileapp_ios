//
//  OMNChangeTableAlertVC.h
//  omnom
//
//  Created by tea on 16.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNTable.h"

@interface OMNChangeTableAlertVC : OMNModalAlertVC

@property (nonatomic, copy) dispatch_block_t didRequestRescanBlock;

- (instancetype)initWithTable:(OMNTable *)table;

@end
