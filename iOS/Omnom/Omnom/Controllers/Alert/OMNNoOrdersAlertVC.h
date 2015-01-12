//
//  OMNNoOrdersAlertVC.h
//  omnom
//
//  Created by tea on 12.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNTable.h"

@interface OMNNoOrdersAlertVC : OMNModalAlertVC

@property (nonatomic, copy) dispatch_block_t didChangeTableBlock;

- (instancetype)initWithTable:(OMNTable *)table;

@end
