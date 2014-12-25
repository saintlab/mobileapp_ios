//
//  OMNRestaurantSchedules.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantSchedule.h"

@interface OMNRestaurantSchedules : NSObject

@property (nonatomic, strong, readonly) OMNRestaurantSchedule *work;
@property (nonatomic, strong, readonly) OMNRestaurantSchedule *breakfast;
@property (nonatomic, strong, readonly) OMNRestaurantSchedule *lunch;

- (instancetype)initWithJsonData:(id)jsonData;

@end
