//
//  OMNMailRuError.m
//  Pods
//
//  Created by tea on 19.04.15.
//
//

#import "OMNMailRuError.h"
NSString *const OMNMailRuErrorDomain = @"OMNMailRuErrorDomain";

@interface AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse;

@end

@implementation OMNMailRuError

+ (OMNMailRuError *)omn_errorWithRequest:(id)request responseOperation:(AFHTTPRequestOperation *)operation {
  return [self omn_errorFromRequest:request response:[operation omn_errorResponse]];
}

+ (OMNMailRuError *)omn_errorFromRequest:(id)request response:(id)response {
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
  
  if (request) {
    userInfo[@"request"] = request;
  }
  if (response) {
    userInfo[@"response"] = response;
  }
  
  if (![response isKindOfClass:[NSDictionary class]]) {
    return [OMNMailRuError errorWithDomain:OMNMailRuErrorDomain code:kOMNMailRuErrorCodeUnknown userInfo:userInfo];
  }
  
  NSInteger code = kOMNMailRuErrorCodeUnknown;
  if (response[@"error"]) {
    
    NSString *description = response[@"error"][@"descr"];
    NSString *codeString = response[@"error"][@"code"];
    
    if ([codeString isEqualToString:@"ERR_CARD_AMOUNT"]) {
      code = kOMNMailRuErrorCodeCardAmount;
    }

    if (description) {
      userInfo[NSLocalizedDescriptionKey] = description;
    }
    
  }

  OMNMailRuError *error = [OMNMailRuError errorWithDomain:OMNMailRuErrorDomain code:code userInfo:userInfo];
  return error;
  
}

@end

@implementation AFHTTPRequestOperation (omn_mailRu)

- (NSDictionary *)omn_errorResponse {
  
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  parametrs[@"error"] = (self.error.userInfo) ?: (@"");
  parametrs[@"url"] = (self.request.URL.absoluteString) ?: (@"");
  if (self.responseString) {
    parametrs[@"response_string"] = self.responseString;
  }
  
  return parametrs;
  
}

@end