//
//  OMNRestaurantScheduleDay.h
//  omnom
//
//  Created by tea on 25.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNRestaurantScheduleDay : NSObject

@property (nonatomic, copy, readonly) NSString *open_time;
@property (nonatomic, assign, readonly) BOOL is_closed;
@property (nonatomic, copy, readonly) NSString *close_time;

- (instancetype)initWithJsonData:(id)jsonData;

@end
