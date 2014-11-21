//
//  OMNDecodeBeaconManager.h
//  restaurants
//
//  Created by tea on 10.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNVisitor+network.h"

@interface OMNVisitorManager : NSObject

+ (instancetype)manager;
/**
 Decode list of OMNBeacon objects and get related visitor
 @param beacons list of @{OMNBeacon} objects
 @param success success callback, contains OMNVisitor object
 @param failure error callback, contains NSError object
 */
- (void)decodeBeacon:(OMNBeacon *)beacon success:(OMNVisitorBlock)success failure:(void (^)(NSError *error))failure;

- (void)decodeQRCode:(NSString *)qrCode success:(OMNVisitorBlock)success failure:(void (^)(NSError *error))failure;

- (void)demoVisitor:(OMNVisitorBlock)completionBlock failure:(void (^)(NSError *error))failureBlock;

- (void)handleBackgroundBeacon:(OMNBeacon *)beacon completion:(dispatch_block_t)completion;

@end
