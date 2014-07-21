//
//  GMenu.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNMenuItem.h"

@interface OMNMenu : NSObject

@property (nonatomic, strong) NSArray *items;

- (instancetype)initWithData:(id)data;

@end