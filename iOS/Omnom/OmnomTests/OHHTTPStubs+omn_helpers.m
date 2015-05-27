//
//  OHHTTPStubs+omn_helpers.m
//  omnom
//
//  Created by tea on 27.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OHHTTPStubs+omn_helpers.h"
#import "NSString+omn_json.h"

@implementation OHHTTPStubs (omn_helpers)

+ (OHHTTPStubs *)omn_stubPath:(NSString *)path jsonFile:(NSString *)file {
  
  return [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
    return [request.URL.path containsString:path];
  } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
    id response = [file omn_jsonObjectNamedForClass:self.class];
    return [OHHTTPStubsResponse responseWithJSONObject:response statusCode:200 headers:@{}];
  }];
  
}

@end
