//
//  OMNConfig.h
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNConfig : NSObject

@property (nonatomic, assign, readonly) BOOL disableOnEntrancePush;
@property (nonatomic, strong, readonly) NSDictionary *mailRuConfig;
@property (nonatomic, strong, readonly) NSDictionary *beaconUUID;
@property (nonatomic, copy, readonly) NSString *mixpanelToken;
@property (nonatomic, copy, readonly) NSString *mixpanelDebugToken;

- (instancetype)initWithJsonData:(id)jsonData;

@end
