//
//  OMNMenuProductModifer.h
//  omnom
//
//  Created by tea on 02.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNMenuModifer : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *parent;

- (instancetype)initWithJsonData:(id)jsonData;

@end
