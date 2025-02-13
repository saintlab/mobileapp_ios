//
//  OMNRestaurantDelivery.h
//  omnom
//
//  Created by tea on 31.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantAddress.h"

@interface OMNDelivery : NSObject

@property (nonatomic, strong) OMNRestaurantAddress *address;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) NSInteger minutes;

+ (instancetype)deliveryWithJsonData:(id)jsonData;

+ (instancetype)delivery;
+ (instancetype)deliveryWithAddress:(OMNRestaurantAddress *)address date:(NSString *)date;
+ (instancetype)deliveryWithAddress:(OMNRestaurantAddress *)address minutes:(NSInteger)minutes;
- (BOOL)readyForLunch;
- (NSDictionary *)parameters;
- (NSDictionary *)addressData;

@end
