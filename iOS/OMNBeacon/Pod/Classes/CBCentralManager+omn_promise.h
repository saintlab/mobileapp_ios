//
//  OMNBluetoothManager.h
//  beacon
//
//  Created by tea on 24.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>
#import <PromiseKit.h>

typedef void(^CBCentralManagerStateBlock)(CBCentralManagerState state);

@interface CBCentralManager (omn_promise)

+ (PMKPromise *)omn_bluetoothEnabled;

@end
