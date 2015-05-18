//
//  OMNRestaurantManagerSpec.m
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNRestaurantManager.h"
#import <OHHTTPStubs.h>
#import <OMNBeacon.h>
#import "NSString+omn_json.h"

SPEC_BEGIN(OMNRestaurantManagerSpec)

describe(@"OMNRestaurantManager", ^{

  context(@"decode", ^{
    
    it(@"should decode from beacon", ^{
      
      id stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {

        return [request.URL.lastPathComponent isEqualToString:@"omnom"];
        
      } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        return [OHHTTPStubsResponse responseWithJSONObject:[@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class] statusCode:200 headers:@{}];
        
      }];
      
      [OMNRestaurantManager decodeBeacons:@[OMNBeacon.demoBeacon]].then(^(NSArray *restaurants) {
        
        [[restaurants should] haveCountOf:1];
        
      }).catch(^(OMNError *error) {
        
      }).finally(^{
        
        [OHHTTPStubs removeStub:stub];
        
      });
      
    });
    
    it(@"should decode qr", ^{
      
      id stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        
        return [request.URL.lastPathComponent isEqualToString:@"qr"];
        
      } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        
        return [OHHTTPStubsResponse responseWithJSONObject:[@"decodeBeacons.json" omn_jsonObjectNamedForClass:self.class] statusCode:200 headers:@{}];
        
      }];
      
      [OMNRestaurantManager decodeQR:@""].then(^(NSArray *restaurants) {
        
        [[restaurants should] haveCountOf:1];
        
      }).catch(^(OMNError *error) {
        
      }).finally(^{
        
        [OHHTTPStubs removeStub:stub];
        
      });
      
    });
    
  });
  
});

SPEC_END
