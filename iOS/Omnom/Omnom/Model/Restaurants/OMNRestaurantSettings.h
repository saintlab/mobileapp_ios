//
//  OMNRestaurantSettings.h
//  omnom
//
//  Created by tea on 11.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNRestaurantSettings : NSObject

@property (nonatomic, assign) BOOL has_menu;
@property (nonatomic, assign) BOOL has_promo;
@property (nonatomic, assign) BOOL has_waiter_call;

- (instancetype)initWithJsonData:(id)jsonData;

@end
