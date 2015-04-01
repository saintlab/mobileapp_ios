//
//  OMNRestaurantAddress.h
//  omnom
//
//  Created by tea on 24.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNRestaurantAddress : NSObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *building;
@property (nonatomic, copy, readonly) NSString *city;
@property (nonatomic, copy, readonly) NSString *street;
@property (nonatomic, copy, readonly) NSString *floor;
@property (nonatomic, strong, readonly) id jsonData;

- (instancetype)initWithJsonData:(id)jsonData;

- (NSString *)text;

@end
