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
#import "OHHTTPStubs+omn_helpers.h"

SPEC_BEGIN(OMNRestaurantManagerSpec)

describe(@"OMNRestaurantManager", ^{

  context(@"decode", ^{
    
    it(@"should decode from beacon", ^{
      
      id stub = [OHHTTPStubs omn_stubPath:@"omnom" jsonFile:@"decodeBeacons.json"];
      
      [OMNRestaurantManager decodeBeacons:@[OMNBeacon.demoBeacon]].then(^(NSArray *restaurants) {
        
        [[restaurants should] haveCountOf:1];
        
      }).catch(^(OMNError *error) {
        
      }).finally(^{
        
        [OHHTTPStubs removeStub:stub];
        
      });
      
    });
    
    it(@"should decode qr", ^{
      
      id stub = [OHHTTPStubs omn_stubPath:@"qr" jsonFile:@"decodeBeacons.json"];
      
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
