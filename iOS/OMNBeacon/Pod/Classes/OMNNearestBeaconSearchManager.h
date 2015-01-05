//
//  OMNBeaconSearchManager.h
//  beacon
//
//  Created by tea on 16.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

extern NSTimeInterval const kBeaconSearchTimout;

#import "OMNBeacon.h"
/**
 *  Менеджер для поиска ближашего бикона
 */
@interface OMNNearestBeaconSearchManager : NSObject


/**
 *  Метод для поиска ближайшего бикона, при запуске создает новый background task который завершится при нахождении бикона или вызове метода stop
 *
 *  @param didFindNearestBeaconBlock как правило блок вызовется 2 раза, первый раз когда найдет любой ближайший бикон, второй раз когда, когда телефон положат на стол, после того как будет определен бикон на столе, менеджер завершит свою работу
 *  @param failureBlock              Если в течении kBeaconSearchTimout не будет найдено не одного бикона рядом, или по каким то другим условиям бикон невозможно найти, вызовется этот блок
 */
- (void)findNearestBeacon:(void(^)(OMNBeacon *beacon, BOOL atTheTable))didFindNearestBeaconBlock failure:(dispatch_block_t)failureBlock;

- (void)stop;

@end
