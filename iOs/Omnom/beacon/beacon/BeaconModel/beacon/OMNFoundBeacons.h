//
//  OMNFoundBeacons.h
//  beacon
//
//  Created by tea on 27.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OMNFoundBeacons : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *atTheTableBeacons;

- (BOOL)updateWithFoundBeacons:(NSArray *)foundBeacons;

@end
