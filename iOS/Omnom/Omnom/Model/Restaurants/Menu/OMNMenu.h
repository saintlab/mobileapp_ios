//
//  GMenu.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuProduct.h"

@interface OMNMenu : NSObject

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithJsonData:(id)data;

@end
