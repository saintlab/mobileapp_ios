//
//  OMNTable.h
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNTable : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *internalTableId;

- (instancetype)initWithJsonData:(id)data;

@end
