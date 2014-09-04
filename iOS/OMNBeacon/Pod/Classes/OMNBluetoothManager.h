//
//  OMNBluetoothManager.h
//  beacon
//
//  Created by tea on 24.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

typedef void(^CBCentralManagerStateBlock)(CBCentralManagerState state);

@interface OMNBluetoothManager : NSObject

@property (nonatomic, assign, readonly) CBCentralManagerState state;

+ (instancetype)manager;

- (void)getBluetoothState:(CBCentralManagerStateBlock)block;

- (void)stop;

@end
