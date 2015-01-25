//
//  OMNMenuCategory.h
//  omnom
//
//  Created by tea on 22.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNMenuProduct.h"

@interface OMNMenuCategory : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *Description;
@property (nonatomic, copy) NSNumber *sort;
@property (nonatomic, strong) id schedule;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSArray *children;
@property (nonatomic, strong) NSArray *products;

- (instancetype)initWithJsonData:(id)jsonData menuProducts:(__weak NSDictionary *)menuProducts level:(NSInteger)level;
- (NSArray *)listItems;

@end
