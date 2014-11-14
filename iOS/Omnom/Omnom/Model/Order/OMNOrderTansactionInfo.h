//
//  OMNOrderTansactionInfo.h
//  omnom
//
//  Created by tea on 14.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

@interface OMNOrderTansactionInfo : NSObject

@property (nonatomic, strong, readonly) NSString *order_id;
@property (nonatomic, strong, readonly) NSString *restaurant_id;
@property (nonatomic, assign, readonly) long long bill_amount;
@property (nonatomic, assign, readonly) long long tips_amount;
@property (nonatomic, assign, readonly) long long total_amount;
@property (nonatomic, assign, readonly) double tips_percent;
@property (nonatomic, strong, readonly) NSString *tips_way;
@property (nonatomic, strong, readonly) NSString *split;

- (instancetype)initWithOrder:(OMNOrder *)order;

@end
