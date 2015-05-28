//
//  UIImage+omn_networkSpec.m
//  omnom
//
//  Created by tea on 28.05.15.
//  Copyright 2015 tea. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "UIImage+omn_network.h"
#import "OMNOperationManager.h"

SPEC_BEGIN(UIImage_omn_networkSpec)

describe(@"UIImage+omn_network", ^{

  context(@"upload", ^{
    
    beforeAll(^{
      [OMNOperationManager setupWithURL:@"https://omnom.staging.saintlab.com" headers:@{}];
    });
    
    afterAll(^{
      [OMNOperationManager setupWithURL:nil headers:@{}];
    });
    
    pending(@"should test at live", nil);
    
    it(@"should not upload nil image", ^{
      
      __block NSString *_url = @"";
      [[UIImage new] omn_upload].then(^(NSString *url) {
        
        _url = url;
        
      });
      
      [[expectFutureValue(_url) shouldEventuallyBeforeTimingOutAfter(3.0)] beNil];
      
    });

    it(@"should upload image", ^{
      
      __block NSString *_url = nil;
      UIGraphicsBeginImageContext(CGSizeMake(1, 1));
      UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      [image omn_upload].then(^(NSString *url) {
        
        _url = url;
        
      });
      
      [[expectFutureValue(_url) shouldEventuallyBeforeTimingOutAfter(3.0)] beNonNil];
      
    });
    
  });
  
});

SPEC_END
