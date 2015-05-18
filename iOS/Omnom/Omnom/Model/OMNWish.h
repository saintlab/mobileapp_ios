//
//  OMNWith.h
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNOrderItem.h"
#import "OMNDelivery.h"

typedef NS_ENUM(NSInteger, OMNWishStatus) {
  kWishStatusUnknown = 0,
  kWishStatusReady,
  kWishStatusCanceled,
};

@interface OMNWish : NSObject

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy, readonly) NSString *restaurant_id;
@property (nonatomic, copy, readonly) NSString *created;
@property (nonatomic, copy, readonly) NSDate *createdDate;
@property (nonatomic, copy, readonly) NSString *table_id;
@property (nonatomic, copy, readonly) NSString *internal_table_id;
@property (nonatomic, copy, readonly) NSString *person;
@property (nonatomic, copy, readonly) NSString *phone;
@property (nonatomic, copy, readonly) NSString *orderNumber;
@property (nonatomic, copy, readonly) NSString *pin;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, assign, readonly) OMNWishStatus status;
@property (nonatomic, strong, readonly) OMNDelivery *delivery;

- (instancetype)initWithJsonData:(id)jsonData;
- (long long)totalAmount;

- (NSAttributedString *)statusText;
- (NSString *)descriptionText;

@end
