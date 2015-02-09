//
//  OMNBill.h
//  omnom
//
//  Created by tea on 29.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OMNBillPayLinkBlock)(NSString *url);

@interface OMNBill : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *mail_restaurant_id;
@property (nonatomic, copy) NSString *table_id;
@property (nonatomic, assign) double revenue;

- (instancetype)initWithJsonData:(id)jsonData;

@end
