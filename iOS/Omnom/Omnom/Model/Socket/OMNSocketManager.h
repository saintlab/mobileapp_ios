//
//  OMNSocketManager.h
//  omnom
//
//  Created by tea on 30.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const OMNSocketIODidReceiveCardIdNotification;
//extern NSString * const OMNSocketIODidReceiveCardIdNotification;


@interface OMNSocketManager : NSObject

+ (instancetype)manager;

- (void)connectWithToken:(NSString *)token;
- (void)leave:(NSString *)roomId;
- (void)join:(NSString *)roomId;

@end
