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
@property (nonatomic, assign) long long int amount;
@property (nonatomic, copy) NSString *table_id;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy) NSString *status;

- (instancetype)initWithJsonData:(id)jsonData;

- (void)linkForAmount:(long long)amount tip:(long long)tipAmount completion:(OMNBillPayLinkBlock)completion;

@end
