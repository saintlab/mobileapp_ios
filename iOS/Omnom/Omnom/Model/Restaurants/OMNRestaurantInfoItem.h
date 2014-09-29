//
//  OMNRestaurantInfoItem.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RestaurantInfoItemType) {
  kRestaurantInfoItemTypeText = 0,
  kRestaurantInfoItemTypeTime,
  kRestaurantInfoItemTypeWifi,
  kRestaurantInfoItemTypeAddress,
  kRestaurantInfoItemTypeSchedule,
  kRestaurantInfoItemTypePhone,
  kRestaurantInfoItemTypeLunch,
  kRestaurantInfoItemTypeBreakfast,
  kRestaurantInfoItemTypeExternaLink,
};

@interface OMNRestaurantInfoItem : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) RestaurantInfoItemType type;
@property (nonatomic, strong, readonly) UIImage *icon;

- (instancetype)initWithJsonData:(id)jsonData;

- (void)open;

@end
