//
//  OMNEnterQRAlertVC.h
//  omnom
//
//  Created by tea on 13.02.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"

typedef void(^OMNDidFindRestaurantsBlock)(NSArray *restaurants);

@interface OMNEnterHashAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNDidFindRestaurantsBlock didFindRestaurantsBlock;

@end
