//
//  OMNError.h
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OMNErrorCode) {
  
  kOMNErrorCodeUnknoun = -1,
  OMNErrorDefault = 0,
  
  kOMNErrorCodeTimedOut,
  kOMNErrorCodeNotConnectedToInternet,
  
  OMNErrorOrderClosed = 300,
  kOMNErrorCodeQrDecode,
  OMNErrorWrongAmount,
  
};

typedef NS_ENUM(NSInteger, OMNUserErrorCode) {
  
  kOMNUserErrorCodeUnknoun = -1,
  kOMNUserErrorCodeNoEmailAndPhone = 1,
  kOMNUserErrorCodeNoSuchUser = 101,
  
};

extern NSString * const OMNErrorDomain;
extern NSString * const OMNUserErrorDomain;

@interface OMNError : NSError

+ (OMNError *)omnnomErrorFromError:(NSError *)error;
+ (OMNError *)omnomErrorFromCode:(NSInteger)code;
+ (OMNError *)userErrorFromCode:(OMNUserErrorCode)code;

@end

@interface NSObject (omn_userError)

- (OMNError *)omn_userError;

@end

@interface NSError (omn_internetError)

- (OMNError *)omn_internetError;

@end