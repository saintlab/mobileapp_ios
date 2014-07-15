//
//  GGOrderItem.h
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNOrderItem : NSObject
<NSCopying>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, strong) UIImage *icon;

- (instancetype)initWithData:(id)data;

- (void)changeSelection;

- (void)deselect;

@end
