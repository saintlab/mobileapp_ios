//
//  OMNFoundBeaconsHandler.m
//  restaurants
//
//  Created by tea on 19.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNFoundBeaconsHandler.h"
#import "OMNBeaconBackgroundManager.h"
#import "OMNDecodeBeacon.h"

@implementation OMNFoundBeaconsHandler

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  
}

- (instancetype)init {
  self = [super init];
  if (self) {
    
    [OMNBeaconBackgroundManager manager];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFoundBackgroundBeacon:) name:OMNBeaconBackgroundManagerDidFoundBeaconNotification object:nil];
    
  }
  return self;
}

- (void)didFoundBackgroundBeacon:(NSNotification *)n {
  
  OMNBeacon *beacon = n.object;
  if (nil == beacon) {
    return;
  }
  
  __weak typeof(self)weakSelf = self;
  [OMNDecodeBeacon decodeBeacons:@[beacon] success:^(NSArray *decodeBeacons) {
    
    [weakSelf handleDecodeBeacons:decodeBeacons];
    NSLog(@"decodeBeacons>%@", decodeBeacons);
    
  } failure:^(NSError *error) {
    
    NSLog(@"%@", error);
    
  }];
  
}

- (void)handleDecodeBeacons:(NSArray *)decodeBeacons {
  
  OMNDecodeBeacon *decodeBeacon = [decodeBeacons firstObject];
  
  if (decodeBeacon) {
    
    
  }
  
}


- (void)showLocalNotificationNowForBeacon:(OMNDecodeBeacon *)beacon {
  
  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  localNotification.hasAction = YES;
  localNotification.alertAction = @"чо каво, тестим сообщение";
  localNotification.alertBody = [NSString stringWithFormat:@"вот что нашли в бг %@", beacon];
  localNotification.applicationIconBadgeNumber = -1;
  localNotification.soundName = UILocalNotificationDefaultSoundName;
  [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
  
}

@end
