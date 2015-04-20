//
//  OMNMailRuError.h
//  Pods
//
//  Created by tea on 19.04.15.
//
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

extern NSString *const OMNMailRuErrorDomain;

typedef NS_ENUM(NSInteger, OMNMailRuErrorCode) {
  
  kOMNMailRuErrorCodeUnknown = -1,
  kOMNMailRuErrorCodeDefault = 0,
  kOMNMailRuErrorCodeCancel,
  kOMNMailRuErrorCodeTimeout,
  kOMNMailRuErrorCodeCardAmount,
  
};

@interface OMNMailRuError : NSError

+ (OMNMailRuError *)omn_errorWithRequest:(id)request responseOperation:(AFHTTPRequestOperation *)operation;
+ (OMNMailRuError *)omn_errorFromRequest:(id)request response:(id)response;

@end
