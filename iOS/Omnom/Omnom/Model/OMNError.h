//
//  OMNError.h
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSInteger, OMNErrorCode) {
  
  kOMNErrorCodeUnknoun = -1,
  kOMNErrorDefault = 0,
  
  kOMNErrorCodeTimedOut,
  kOMNErrorCodeNotConnectedToInternet,
  
  kOMNErrorOrderClosed = 3000,
  kOMNErrorRestaurantUnavailable,
  kOMNErrorCodeQrDecode,
  kOMNErrorCancel,
  kOMNErrorWrongAmount,
  
};

typedef NS_ENUM(NSInteger, OMNUserErrorCode) {
  
  kOMNUserErrorCodeUnknoun = -1,
  kOMNUserErrorCodeNoEmailAndPhone = 1,
  kOMNUserErrorCodeNoSuchUser = 101,
  kOMNUserErrorCodeUserExist = 107,
  
};

extern NSString * const OMNErrorDomain;
extern NSString * const OMNUserErrorDomain;

@interface OMNError : NSError

+ (OMNError *)billErrorFromResponse:(id)response;
+ (OMNError *)omnnomErrorFromError:(NSError *)error;
+ (OMNError *)omnomErrorFromCode:(NSInteger)code;
+ (OMNError *)omnomErrorFromRequest:(id)request response:(id)response;
+ (OMNError *)userErrorFromCode:(OMNUserErrorCode)code;

- (UIImage *)circleImage;

@end

@interface NSObject (omn_userError)

- (OMNError *)omn_userError;

@end

@interface NSError (omn_internetError)

- (OMNError *)omn_internetError;

@end

@interface AFHTTPRequestOperation (omn_error)

- (NSDictionary *)omn_error;

@end