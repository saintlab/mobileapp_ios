//
//  GRestaurant.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenu.h"
#import "OMNOrder.h"
#import "OMNRestaurantInfo.h"
#import "OMNPushTexts.h"
#import "OMNRestaurantDecoration.h"
#import "OMNRestaurantSettings.h"
#import "OMNError.h"
#import "OMNRestaurantAddress.h"
#import "OMNRestaurantSchedules.h"
#import "OMNTable.h"
#import "OMNOrder.h"
#import "OMNDelivery.h"

#define kEntranceModeOnTable @"on-table"
#define kEntranceModeIn @"for-here"
#define kEntranceModeLunch @"lunch"
#define kEntranceModeBar @"bar"
#define kEntranceModeTakeAway @"take-away"
#define kEntranceModeDemo @"demo"

extern NSString * const OMNRestaurantNotificationLaunchKey;


@interface OMNRestaurant : NSObject
<NSCoding>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, assign, readonly) BOOL is_demo;
@property (nonatomic, assign, readonly) BOOL available;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *Description;
@property (nonatomic, assign, readonly) NSString *entrance_mode;
@property (nonatomic, strong, readonly) NSArray *entrance_modes;
@property (nonatomic, assign, readonly) double distance;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSURL *orders_paid_url;
@property (nonatomic, strong, readonly) NSArray *tables;
@property (nonatomic, strong, readonly) NSArray *orders;
@property (nonatomic, strong, readonly) NSArray *delivery_dates;
@property (nonatomic, strong, readonly) OMNRestaurantDecoration *decoration;
@property (nonatomic, strong, readonly) OMNRestaurantAddress *address;
@property (nonatomic, strong, readonly) OMNPushTexts *mobile_texts;
@property (nonatomic, strong, readonly) OMNRestaurantSettings *settings;
@property (nonatomic, strong, readonly) OMNRestaurantSchedules *schedules;
@property (nonatomic, strong) OMNRestaurantInfo *info;

- (instancetype)initWithJsonData:(id)jsonData;

- (BOOL)hasTable;
- (BOOL)hasOrders;
- (BOOL)canProcess;

@end

