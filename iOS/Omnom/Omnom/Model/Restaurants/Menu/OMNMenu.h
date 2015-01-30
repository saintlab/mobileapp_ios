//
//  GMenu.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuCategory.h"
#import "OMNMenuProduct.h"

@interface OMNMenu : NSObject

@property (nonatomic, strong) NSMutableDictionary *products;
@property (nonatomic, strong) NSArray *categories;

- (instancetype)initWithJsonData:(id)data;
- (void)resetSelection;
- (long long)total;

@end
