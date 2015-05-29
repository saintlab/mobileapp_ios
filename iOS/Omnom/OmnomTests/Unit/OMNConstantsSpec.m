//
//  OMNConstantsSpec.m
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNConstants.h"
#import "OMNQRLaunch.h"
#import <OHHTTPStubs.h>
#import "NSString+omn_json.h"
#import <OMNBeacon.h>
#import "OMNAnalitics.h"
#import <SSKeychain.h>
#import "OMNOperationManager.h"
#import "OMNAuthorizationManager.h"

SPEC_BEGIN(OMNConstantsSpec)

describe(@"OMNConstants", ^{

  context(@"setup", ^{
    
    it(@"should check initial condition", ^{
      
      [[OMNBeacon.beaconUUID should] beNil];
      [[@([OMNAnalitics analitics].ready) should] equal:@(NO)];
      [[[OMNOperationManager sharedManager] should] beNil];
      [[[OMNAuthorizationManager sharedManager] should] beNil];
      [[OMNConstants.mixpanelToken should] beNil];
      [[OMNConstants.mixpanelDebugToken should] beNil];
      
    });
    
    it(@"should setup with qr", ^{
      
      __block id stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        return [request.URL.lastPathComponent isEqualToString:@"config"];
      } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
        id response = [@"config_stub.json" omn_jsonObjectNamedForClass:self.class];
        return [OHHTTPStubsResponse responseWithJSONObject:response statusCode:200 headers:@{}];
      }];
      
      OMNLaunch *launch = [[OMNQRLaunch alloc] initWithQR:@"" config:nil];
      [OMNConstants setupWithLaunch:launch].then(^(OMNConfig *config) {
        
        [[config should] beNonNil];
        [[config.mixpanelToken should] beNonNil];
        [[config.mixpanelDebugToken should] beNonNil];
        [[config.mailRuConfig should] beNonNil];
        [[OMNBeacon.beaconUUID should] beNonNil];
        [[@(SSKeychain.accessibilityType == kSecAttrAccessibleAlwaysThisDeviceOnly) should] beYes];
        
      }).catch(^(OMNError *error) {
        
        [[error should] beNil];
        
      }).finally(^{
        
        [[[OMNOperationManager sharedManager] should] beNonNil];
        [[[OMNOperationManager sharedManager].baseURL.absoluteString should] equal:[OMNConstants baseUrlString]];
        
        [[[OMNAuthorizationManager sharedManager] should] beNonNil];
        [[[OMNAuthorizationManager sharedManager].baseURL.absoluteString should] equal:[OMNConstants authorizationUrlString]];
        
        [OHHTTPStubs removeStub:stub];
        stub = nil;
        
      });
    
      [[expectFutureValue(stub) shouldEventually] beNil];
      
    });
    
  });
  
  context(@"config", ^{
    
    it(@"should return empty config", ^{
      
      [[[OMNConstants configWithName:nil] should] beNil];
      [[[OMNConstants configWithName:@"хрень"] should] beNil];
      
    });
    
    it(@"should return valid config", ^{
      
      [[[OMNConstants configWithName:kOMNConfigNameStand] should] beNonNil];
      
    });
    
  });
  
});

SPEC_END
