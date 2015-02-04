//
//  OMNGuest.h
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrderItem.h"

@interface OMNGuest : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, assign, readonly) NSInteger index;
@property (nonatomic, assign, readonly) long long total;
@property (nonatomic, assign, readonly) long long selectedItemsTotal;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong, readonly) NSArray *items;

- (instancetype)initWithID:(NSString *)id index:(NSInteger)index orderItems:(NSArray *)orderItems;
- (BOOL)hasSelectedItems;
- (BOOL)hasProducts;
- (void)deselectAllItems;

@end
