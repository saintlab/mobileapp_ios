//
//  OHHTTPStubs+omn_helpers.h
//  omnom
//
//  Created by tea on 27.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OHHTTPStubs.h"

@interface OHHTTPStubs (omn_helpers)

+ (OHHTTPStubs *)omn_stubPath:(NSString *)path jsonFile:(NSString *)file;

@end
