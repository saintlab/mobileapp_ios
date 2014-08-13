//
//  OMNRestaurantInfo.h
//  omnom
//
//  Created by tea on 13.08.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNRestaurantInfoItem.h"

@interface OMNRestaurantInfo : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *feedItems;
@property (nonatomic, strong) NSArray *shortItems;
@property (nonatomic, strong) NSArray *fullItems;
@property (nonatomic, assign) BOOL selected;

- (instancetype)initWithJsonData:(id)jsonData;

@end
