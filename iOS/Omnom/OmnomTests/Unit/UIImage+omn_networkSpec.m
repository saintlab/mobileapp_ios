//
//  UIImage+omn_networkSpec.m
//  omnom
//
//  Created by tea on 27.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "UIImage+omn_network.h"
#import "OHHTTPStubs+omn_helpers.h"
#import "OMNOperationManager.h"


#define kOMNOperationManagerTestURL @"https://omnom.omnom.menu"

SPEC_BEGIN(UIImage_omn_networkSpec)

describe(@"UIImage+omn_network", ^{

  beforeAll(^{
    [OMNOperationManager setupWithURL:kOMNOperationManagerTestURL headers:nil];
  });
  
  afterAll(^{
    [OMNOperationManager setupWithURL:nil headers:nil];
  });
  
  context(@"upload image", ^{
    
    it(@"should upload image", ^{
      
      __block id stub = [OHHTTPStubs omn_stubPath:@"upload" jsonFile:@"images_upload_stub.json"];
      
      UIImage *image = [UIImage new];
      [image omn_upload].then(^(NSString *avatar) {
        
        [[avatar should] beNonNil];
        
      }).finally(^{
        
        [OHHTTPStubs removeStub:stub];
        stub = nil;
        
      });
      
      [[expectFutureValue(stub) shouldEventually] beNil];
      
    });
    
  });
  
});

SPEC_END
