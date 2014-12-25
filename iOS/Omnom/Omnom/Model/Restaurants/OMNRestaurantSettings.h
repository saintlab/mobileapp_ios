//
//  OMNRestaurantSettings.h
//  omnom
//
//  Created by tea on 11.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNRestaurantSettings : NSObject

@property (nonatomic, assign, readonly) BOOL has_menu;
@property (nonatomic, assign, readonly) BOOL has_promo;
@property (nonatomic, assign, readonly) BOOL has_waiter_call;
@property (nonatomic, assign, readonly) BOOL has_bar;
@property (nonatomic, assign, readonly) BOOL has_pre_order;
@property (nonatomic, assign, readonly) BOOL has_table_order;

- (instancetype)initWithJsonData:(id)jsonData;

@end
