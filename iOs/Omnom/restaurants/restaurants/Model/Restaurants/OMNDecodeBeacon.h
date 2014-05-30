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

@interface OMNDecodeBeacon : OMNBeacon

@property (nonatomic, copy) NSString *tableId;
@property (nonatomic, copy) NSString *restaurantId;

//@property (nonatomic, strong) OMNTable *table;
//@property (nonatomic, strong) OMNRestaurant *restaurant;

- (instancetype)initWithData:(id)data;

/**
 Decode list of OMNBeacon objects and get related restaurant and table info
 @param beacons list of OMNDecodeBeacon objects
 @param success success callback, contains list of OMNDecodeBeacon objects
 @param failure error callback, contains NSError object
 */
+ (void)decodeBeacons:(NSArray *)beacons success:(OMNBeaconsBlock)success failure:(OMNErrorBlock)failure;

@end
