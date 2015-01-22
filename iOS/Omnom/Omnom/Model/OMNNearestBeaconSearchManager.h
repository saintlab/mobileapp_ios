//
//  OMNBeaconSearchManager.h
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

/**
 *  Менеджер для поиска ближашего бикона
 */
@interface OMNNearestBeaconSearchManager : NSObject

+ (instancetype)sharedManager;
- (instancetype)init __attribute__((unavailable("init not available, call sharedManager instead")));
/**
 *  Метод для поиска ближайших биконов, при запуске создает новый background task который завершится при нахождении биконов или вызове метода stop, после того как будет определен бикон, менеджер завершит свою работу
 *
 *  @param didFindNearestBeaconBlock @param beacons найденые биконы(OMNBeacon)
 *  @param failureBlock              Если в течении kBeaconSearchTimeout не будет найдено не одного бикона рядом, или по каким то другим условиям бикон невозможно найти, вызовется этот блок
 */
- (void)findNearestBeaconsWithCompletion:(dispatch_block_t)didFindNearestBeaconBlock;

- (void)stop;

@end
