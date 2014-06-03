//
//  OMNConstants.h
//  restaurants
//
//  Created by tea on 05.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSString * const kBaseUrlString;
extern NSString * const kAuthorizationUrlString;

extern NSString * const kBeaconUUIDString;

typedef void(^OMNErrorBlock)(NSError *error);
typedef void(^OMNDataBlock)(id data);

#define kUseStubData 0
#define kUseStubBeacon 1