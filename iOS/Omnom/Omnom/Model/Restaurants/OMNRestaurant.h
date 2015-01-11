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

typedef NS_ENUM(NSInteger, OMNRestaurantMode) {
  kRestaurantModeInside = 0,
  kRestaurantModePreorder,
  kRestaurantModeBookTable
};

extern NSString * const OMNRestaurantOrdersDidChangeNotification;
extern NSString * const OMNRestaurantNotificationLaunchKey;

@interface OMNRestaurant : NSObject
<NSCoding>

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign) BOOL is_demo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, assign) OMNRestaurantMode mode;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, strong, readonly) NSArray *tables;
@property (nonatomic, strong, readonly) NSArray *orders;
@property (nonatomic, strong, readonly) OMNRestaurantDecoration *decoration;
@property (nonatomic, strong, readonly) OMNRestaurantAddress *address;
@property (nonatomic, strong, readonly) OMNPushTexts *mobile_texts;
@property (nonatomic, strong, readonly) OMNRestaurantSettings *settings;
@property (nonatomic, strong, readonly) OMNRestaurantSchedules *schedules;
@property (nonatomic, strong) OMNRestaurantInfo *info;

- (instancetype)initWithJsonData:(id)jsonData;

- (BOOL)hasTable;

@end

