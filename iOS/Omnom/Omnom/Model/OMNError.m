//
//  OMNError.m
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNError.h"
#import <OMNMailRuAcquiring.h>

NSString * const OMNErrorDomain = @"OMNErrorDomain";
NSString * const OMNUserErrorDomain = @"OMNUserErrorDomain";
NSString * const OMNForbiddenWishProductsKey = @"forbidden";

@implementation OMNError

+ (OMNError *)omnnomErrorFromError:(NSError *)error {
  
  OMNError *omnomError = nil;
  
  if ([error.domain isEqualToString:NSURLErrorDomain]) {
    
    switch (error.code) {
      case NSURLErrorTimedOut: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeTimedOut];
      } break;
      case NSURLErrorNotConnectedToInternet: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeNotConnectedToInternet];
      } break;
      default: {
        omnomError = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
      } break;
    }
    
  }
  else if ([error.domain isEqualToString:OMNMailRuErrorDomain]) {
    
    switch ((OMNMailRuErrorCode)error.code) {
      case kOMNMailRuErrorCodeCardAmount: {
        omnomError = [self omnomErrorFromCode:kOMNErrorWrongCardAmount];
      } break;
      case kOMNMailRuErrorCodeCancel: {
        omnomError = [self omnomErrorFromCode:kOMNErrorCancel];
      } break;
      default: {
        omnomError = [OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorCodeUnknoun userInfo:error.userInfo];
      } break;
    }
    
  }
  else {
    
    omnomError = [self omnomErrorFromCode:error.code];
    
  }
  
  return omnomError;
  
}

+ (OMNError *)omnomErrorFromRequest:(id)request response:(id)response {
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:3];
  if (request) {
    userInfo[@"request"] = request;
  }
  if (response) {
    userInfo[@"response"] = response;
  }
  return [OMNError errorWithDomain:OMNErrorDomain code:kOMNErrorCodeUnknoun userInfo:userInfo];
  
}

+ (NSString *)descriptionFromCode:(NSInteger)code {
  
  NSString *description = nil;
  switch (code) {
    case kOMNErrorCodeNotConnectedToInternet: {
      description = kOMN_ERROR_MESSAGE_NO_INTERNET;
    } break;
    case kOMNErrorCodeTimedOut: {
      description = kOMN_ERROR_MESSAGE_NO_CONNECTION;
    } break;
    case kOMNErrorOrderClosed: {
      description = kOMN_ERROR_MESSAGE_ORDER_CLOSED;
    } break;
    case kOMNErrorCodeQrDecode: {
      description = kOMN_ERROR_MESSAGE_QR_DECODE;
    } break;
    case kOMNErrorWrongCardAmount: {
      description = kOMN_ERROR_MESSAGE_PAYMENT_ERROR;
    } break;
    case kOMNErrorRestaurantUnavailable: {
      description = kOMN_ERROR_MESSAGE_RESTAURANT_OFFLINE;
    } break;
    case kOMNErrorCodeUnknoun:
    default: {
      description = kOMN_ERROR_MESSAGE_UNKNOWN_ERROR;
    } break;
  }
  return description;
  
}

+ (OMNError *)omnomErrorFromCode:(NSInteger)code {
  return [OMNError errorWithDomain:OMNErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : [self descriptionFromCode:code]}];
}

+ (OMNError *)userErrorFromCode:(OMNUserErrorCode)code {
  
  NSString *description = nil;
  
  switch (code) {
    case kOMNUserErrorCodeNoEmailAndPhone: {
      description = kOMN_ERROR_MESSAGE_ENTER_PHONE_EMAIL;
    } break;
    default:
      break;
  }
  
  NSDictionary *userInfo = nil;
  if (description) {
    userInfo = @{NSLocalizedDescriptionKey : description};
  }
  
  return [OMNError errorWithDomain:OMNUserErrorDomain code:code userInfo:userInfo];
  
}

+ (OMNError *)billErrorFromResponse:(id)response {
  
  if (![response isKindOfClass:[NSDictionary class]]) {
    return [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
  }
  
  OMNError *error = nil;
  NSString *status = response[@"status"];
  if ([status isEqualToString:@"new"]) {
    //no error
  }
  else if ([status isEqualToString:@"paid"] ||
      [status isEqualToString:@"order_closed"]) {
    
    error = [OMNError omnomErrorFromCode:kOMNErrorOrderClosed];
    
  }
  else if ([status isEqualToString:@"restaurant_not_available"]) {
    
    error = [OMNError omnomErrorFromCode:kOMNErrorRestaurantUnavailable];
    
  }
  else {
    
    error = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];
    
  }

  return error;
  
}

- (UIImage *)circleImage {
  
  UIImage *circleImage = nil;
  
  switch (self.code) {
    case kOMNErrorCodeTimedOut: {
      circleImage = [UIImage imageNamed:@"noise_icon_big"];
    } break;
    case kOMNErrorCodeNotConnectedToInternet: {
      circleImage = [UIImage imageNamed:@"unlinked_icon_big"];
    } break;
    case kOMNErrorCodeQrDecode: {
      circleImage = [UIImage imageNamed:@"error_icon_big"];
    } break;
    case kOMNErrorCodeUnknoun: {
      circleImage = [UIImage imageNamed:@"error_icon_big"];
    } break;
  }
  
  return circleImage;
  
}

@end

@implementation NSObject (omn_userError)

- (OMNError *)omn_userError {

  OMNError *error = [OMNError omnomErrorFromCode:kOMNErrorCodeUnknoun];

  if (![self isKindOfClass:[NSDictionary class]]) {
    return error;
  }

  NSDictionary *dictionary = (NSDictionary *)self;
  NSString *message = dictionary[@"error"][@"message"];
  if (message) {

    error = [OMNError errorWithDomain:OMNUserErrorDomain
                                code:[dictionary[@"error"][@"code"] integerValue]
                            userInfo:@{NSLocalizedDescriptionKey : message}];

  }

  return error;

}

@end

@implementation AFHTTPRequestOperation (omn_error)

- (OMNError *)omn_internetError {
  
  NSInteger code = kOMNErrorCodeUnknoun;
  if (NSURLErrorTimedOut == self.error.code) {
    code = kOMNErrorCodeTimedOut;
  }
  else if (NSURLErrorNotConnectedToInternet == self.error.code) {
    code = kOMNErrorCodeNotConnectedToInternet;
  }
  else if (501 == self.response.statusCode) {
    code = kOMNErrorInvalidUserToken;
  }
  
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  userInfo[@"response_string"] = (self.responseString) ?: (@"");
  userInfo[@"headers"] = (self.response.allHeaderFields) ?: (@"");
  userInfo[@"url"] = (self.request.URL.absoluteString) ?: (@"");
  userInfo[@"status_code"] = @(self.response.statusCode);
  userInfo[NSLocalizedDescriptionKey] = [OMNError descriptionFromCode:code];
  return [OMNError errorWithDomain:OMNErrorDomain code:code userInfo:userInfo];
  
}

- (NSDictionary *)omn_error {
  
  NSMutableDictionary *parametrs = [NSMutableDictionary dictionary];
  if (self.response.allHeaderFields) {
    
  }
  if (self.responseString) {
    parametrs[@"response_string"] = self.responseString;
  }
  return parametrs;
  
}

@end