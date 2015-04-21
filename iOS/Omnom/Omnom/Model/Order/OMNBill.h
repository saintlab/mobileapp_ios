//
//  OMNBill.h
//  omnom
//
//  Created by tea on 29.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNError.h"

@class OMNBill;

typedef void(^OMNBillBlock)(OMNBill *bill);

@interface OMNBill : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mail_restaurant_id;
@property (nonatomic, copy) NSString *table_id;
@property (nonatomic, assign) double revenue;

- (instancetype)initWithJsonData:(id)jsonData;
+ (instancetype)billWithJsonData:(id)jsonData error:(OMNError **)error;

@end
