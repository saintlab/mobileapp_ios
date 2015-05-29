//
//  OMNWish+omn_networkSpec.m
//  omnom
//
//  Created by tea on 28.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "OMNWish+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNBarVisitor.h"
#import "NSString+omn_json.h"
#import "OMNRestaurant+omn_network.h"
#import "OMNVisitor+omn_network.h"

#define kValidAuthToken @"NHbftHNaOyONToFZxUkecdcuo6zOu03U"
#define kInvalidAuthToken @"kInvalidAuthToken"

SPEC_BEGIN(OMNWish_omn_networkSpec)

describe(@"OMNWish+omn_network", ^{

  beforeAll(^{
    [OMNOperationManager setupWithURL:@"https://omnom.staging.saintlab.com" headers:@{}];
  });
  
  afterAll(^{
    [OMNOperationManager setupWithURL:nil headers:@{}];
  });
  
  pending(@"should test at live", nil);
  
  OMNBarVisitor *(^stubBarVisitor)() = ^OMNBarVisitor *() {
    
    id staging_restaurants = [@"staging_restaurants_stub.json" omn_jsonObjectNamedForClass:self.class];
    NSArray *restaurants = [staging_restaurants omn_decodeRestaurants];
    OMNBarVisitor *barVisitor = [OMNBarVisitor visitorWithRestaurant:[restaurants firstObject] delivery:[OMNDelivery delivery]];
    return barVisitor;
    
  };
  
  context(@"create wish", ^{
    
    it(@"should create wish with no items", ^{
      
      __block OMNWish *_wish = nil;
      OMNVisitor *visitor = stubBarVisitor();
      [OMNOperationManager setAuthenticationToken:kValidAuthToken];
      [visitor createWish:@[]].then(^(OMNWish *wish) {
        
        _wish = wish;
        
      });
      [[expectFutureValue(_wish) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[theValue(_wish.status) should] equal:theValue(kWishStatusPending)];
      
      __block OMNWish *_remoteWish = nil;
      [OMNWish wishWithID:_wish.id].then(^(OMNWish *wish) {
        
        _remoteWish = wish;
        
      });
      [[expectFutureValue(_remoteWish) shouldEventuallyBeforeTimingOutAfter(10.0)] beNonNil];
      [[_remoteWish.id should] equal:_wish.id];
      [[theValue(_remoteWish.status) should] equal:theValue(kWishStatusPending)];
      
    });
    
    it(@"shouldn't create wish with auth error", ^{
      
      __block OMNError *_error = nil;
      OMNVisitor *visitor = stubBarVisitor();
      [OMNOperationManager setAuthenticationToken:kInvalidAuthToken];
      [visitor createWish:@[]].catch(^(OMNError *error) {
        
        _error = error;
        
      });
      [[expectFutureValue(_error) shouldEventuallyBeforeTimingOutAfter(3.0)] beNonNil];
      [[theValue(_error.code) should] equal:theValue(kOMNErrorInvalidUserToken)];
      
    });
    
  });
  
  context(@"get wish", ^{
    
    it(@"should receive with with status = created", ^{

      __block OMNWish *_wish = nil;
      [OMNWish wishWithID:@"5566f239d323c6dd270ef4fd"].then(^(OMNWish *wish) {
        
        _wish = wish;
        
      });
      [[expectFutureValue(_wish) shouldEventuallyBeforeTimingOutAfter(3.0)] beNonNil];
      
      
    });
    
  });
  
});

SPEC_END
