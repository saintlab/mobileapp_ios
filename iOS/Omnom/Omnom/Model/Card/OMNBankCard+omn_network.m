//
//  OMNBankCard+omn_network.m
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNBankCard+omn_network.h"
#import "OMNOperationManager.h"
#import <OMNMailRuAcquiring.h>
#import "OMNAnalitics.h"
#import "OMNError.h"

@implementation OMNBankCard (omn_network)

- (PMKPromise *)omn_delete {
  
  NSString *path = [NSString stringWithFormat:@"/cards/%@", self.id];
  return [PMKPromise new:^(PMKFulfiller fulfill, PMKRejecter reject) {
    
    [[OMNOperationManager sharedManager] DELETE:path parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
      if ([responseObject omn_isSuccessResponse]) {
        
        fulfill(responseObject);
        
      }
      else {
        
        reject([OMNError omnomErrorFromRequest:path response:responseObject]);
        
      }
      
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      
      reject([OMNError omnomErrorFromRequest:path response:[operation omn_error]]);
      
    }];
    
  }];

  
}

+ (void)getCardsWithCompletion:(void(^)(NSArray *cards))completionBlock failure:(void(^)(NSError *error))failureBlock {
  
  NSAssert(completionBlock != nil, @"completionBlock is nil");
  NSAssert(failureBlock != nil, @"complitionBlock is nil");
  
  NSString *path = [NSString stringWithFormat:@"/cards"];
  [[OMNOperationManager sharedManager] GET:path parameters:nil success:^(AFHTTPRequestOperation *operation, id response) {
    
    [response decodeCardData:completionBlock failure:failureBlock];
    
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    failureBlock(error);
    
  }];
}

@end

@implementation NSDictionary (omn_decodeCardData)

- (void)decodeCardData:(void(^)(NSArray *))completionBlock failure:(void(^)(NSError *))failureBlock {
  
  if ([self isKindOfClass:[NSDictionary class]]) {
    
    NSArray *rawCards = self[@"cards"];
    if (rawCards) {
      NSMutableArray *cards = [NSMutableArray arrayWithCapacity:rawCards.count];
      [rawCards enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        OMNBankCard *card = [[OMNBankCard alloc] initWithJsonData:obj];
        [cards addObject:card];
        
      }];
      completionBlock([cards copy]);
    }
    else {
      failureBlock(nil);
    }
    
  }
  else {
    failureBlock(nil);
  }
  
}

@end