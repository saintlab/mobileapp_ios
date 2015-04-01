//
//  OMNRestaurantDelivery.h
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantAddress.h"

@interface OMNRestaurantDelivery : NSObject

@property (nonatomic, strong) OMNRestaurantAddress *address;
@property (nonatomic, copy) NSString *date;

+ (instancetype)deliveryWithAddress:(OMNRestaurantAddress *)address date:(NSString *)date;
- (BOOL)readyForDelivery;
- (NSDictionary *)addressData;

@end
