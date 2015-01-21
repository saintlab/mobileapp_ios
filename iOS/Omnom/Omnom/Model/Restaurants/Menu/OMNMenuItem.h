//
//  OMNMenuItem.h
//  omnom
//
//  Created by tea on 20.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNMenuItem : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *parent_id;
@property (nonatomic, copy) NSString *name;

- (instancetype)initWithJsonData:(id)data;

@end
