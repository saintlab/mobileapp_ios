//
//  OMNLaunchOptions.h
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNLaunchOptions : NSObject

@property (nonatomic, copy, readonly) NSString *customConfigName;

- (instancetype)initWithLaunchOptions:(NSDictionary *)launchOptions;

@end
