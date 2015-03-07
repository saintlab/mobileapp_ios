//
//  GMenu.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuCategory.h"
#import "OMNMenuProduct.h"
#import "OMNMenuModifer.h"

extern NSString * const OMNMenuDidResetNotofocation;

@interface OMNMenu : NSObject

@property (nonatomic, strong) NSDictionary *products;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSDictionary *modifiers;

- (instancetype)initWithJsonData:(id)data;
- (void)resetSelection;
- (long long)total;
- (BOOL)hasPreorderedItems;

@end
