//
//  OMNQR.h
//  omnom
//
//  Created by tea on 30.09.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNQR : NSObject

@property (nonatomic, copy) NSString *code;

- (instancetype)initWithJsonData:(id)jsonData;
- (BOOL)isValid;

@end
