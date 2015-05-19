//
//  OMNConfig.m
//  omnom
//
//  Created by tea on 18.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNConfig.h"

@implementation OMNConfig

- (instancetype)initWithJsonData:(id)jsonData {
  self = [super init];
  if (self) {
    
    _mailRuConfig = jsonData[@"mail_ru"];
    _beaconUUID = jsonData[@"uuid"];
    NSDictionary *tokens = jsonData[@"tokens"];
    _mixpanelToken = tokens[@"MixpanelToken"];
    _mixpanelDebugToken = tokens[@"MixpanelTokenDebug"];

  }
  return self;
}

@end
