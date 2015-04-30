//
//  OMNWish+omn_network.m
//  omnom
//
//  Created by tea on 30.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNWish+omn_network.h"
#import "OMNOperationManager.h"
#import "OMNError.h"

@implementation OMNWish (omn_network)

+ (PMKPromise *)wishWithID:(NSString *)wishID {
  
  NSString *path = [NSString stringWithFormat:@"wishes/%@", wishID];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      OMNWish *wish = [[OMNWish alloc] initWithJsonData:responseObject];
      fulfill(wish);
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([operation omn_internetError]);
      
    }];

  }];
  
}

@end
