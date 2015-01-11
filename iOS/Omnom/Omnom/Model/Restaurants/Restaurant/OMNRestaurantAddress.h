//
//  OMNRestaurantAddress.h
//  omnom
//
//  Created by tea on 24.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNRestaurantAddress : NSObject

@property (nonatomic, copy) NSString *building;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *floor;

- (instancetype)initWithJsonData:(id)jsonData;

- (NSString *)text;

@end
