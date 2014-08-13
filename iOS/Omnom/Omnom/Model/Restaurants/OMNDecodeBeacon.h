//
//  OMNDecodeBeacon.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBeacon.h"
#import "OMNRestaurant.h"
#import "OMNTable.h"
#import "OMNConstants.h"

typedef void(^OMNBeaconsBlock)(NSArray *decodeBeacons);

@interface OMNDecodeBeacon : NSObject
<NSCoding>

@property (nonatomic, copy) NSString *uuid;
@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *restaurantId;
@property (nonatomic, strong) NSDate *foundDate;

//@property (nonatomic, strong) OMNTable *table;
@property (nonatomic, strong) OMNRestaurant *restaurant;

- (instancetype)initWithData:(id)data;

- (BOOL)readyForPush;

@end
