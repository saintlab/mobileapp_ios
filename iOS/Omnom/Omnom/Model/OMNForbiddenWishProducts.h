//
//  OMNForbiddenWishProducts.h
//  omnom
//
//  Created by tea on 29.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNForbiddenWishProducts : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *ids;
@property (nonatomic, strong, readonly) NSMutableArray *names;

- (instancetype)initWithJsonData:(id)jsonData;

@end
