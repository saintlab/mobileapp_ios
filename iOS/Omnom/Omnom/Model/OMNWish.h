//
//  OMNWith.h
//  omnom
//
//  Created by tea on 28.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNWish : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *restaurant_id;
@property (nonatomic, copy) NSString *created;
@property (nonatomic, copy) NSString *internal_table_id;
@property (nonatomic, copy) NSString *person;
@property (nonatomic, copy) NSString *phone;

- (instancetype)initWithJsonData:(id)jsonData;

@end
