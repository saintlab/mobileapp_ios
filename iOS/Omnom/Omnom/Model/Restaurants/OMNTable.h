//
//  OMNTable.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNTable : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *internal_id;
@property (nonatomic, copy) NSString *restaurant_id;

- (instancetype)initWithJsonData:(id)data;

@end

@interface NSObject (omn_tables)

- (NSArray *)omn_tables;

@end