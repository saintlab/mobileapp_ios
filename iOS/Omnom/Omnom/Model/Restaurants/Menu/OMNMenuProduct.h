//
//  GMenuItem.h
//  restaurants
//
//  Created by tea on 13.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNMenuProduct : NSObject

@property (nonatomic, copy) NSString *internalId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double quantity;
@property (nonatomic, copy) NSString *parent;
@property (nonatomic, copy) NSString *image;

- (instancetype)initWithJsonData:(id)data;

@end
