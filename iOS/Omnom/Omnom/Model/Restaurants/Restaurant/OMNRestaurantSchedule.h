//
//  OMNRestaurantSchedule.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantScheduleDay.h"

@interface OMNRestaurantSchedule : NSObject

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) NSDictionary *days;

- (instancetype)initWithJsonData:(id)jsonData;

- (NSString *)fromToText;

@end
