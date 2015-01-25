//
//  OMNMenuProductDetails.h
//  omnom
//
//  Created by tea on 23.01.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNMenuProductDetails : NSObject

@property (nonatomic, assign) double weight;
@property (nonatomic, assign) double energy_total;

- (instancetype)initWithJsonData:(id)jsonData;
- (NSString *)displayText;

@end
