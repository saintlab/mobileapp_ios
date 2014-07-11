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

+ (instancetype)manager;

- (void)getBluetoothState:(CBCentralManagerStateBlock)block;

- (void)stop;

@end
