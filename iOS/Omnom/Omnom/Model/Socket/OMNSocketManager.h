//
//  OMNSocketManager.h
//  omnom
//
//  Created by tea on 30.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const OMNSocketIOOrderDidPayNotification;
extern NSString * const OMNSocketIOOrderDidChangeNotification;
extern NSString * const OMNSocketIOOrderDidCloseNotification;
extern NSString * const OMNSocketIOWaiterCallDoneNotification;

extern NSString * const OMNOrderDataKey;
extern NSString * const OMNPaymentDataKey;

@interface OMNSocketManager : NSObject

@property (nonatomic, strong, readonly) NSMutableSet *rooms;

+ (instancetype)manager;

- (void)connectWithToken:(NSString *)token;
- (void)connectWithToken:(NSString *)token completion:(dispatch_block_t)completionBlock;
- (void)disconnectAndLeaveAllRooms:(BOOL)leave;
- (void)leave:(NSString *)roomId;
- (void)join:(NSString *)roomId;

- (void)subscribe:(NSString *)event block:(void (^)(id data))block;
- (void)unsubscribe:(NSString *)event;
- (void)echo:(NSString *)message;

@end
