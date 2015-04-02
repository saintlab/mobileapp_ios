//
//  OMNSelectMinutesAlertVC.h
//  omnom
//
//  Created by tea on 02.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"

typedef void(^OMNSelectMinutesBlock)(NSInteger minutes);

@interface OMNSelectMinutesAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNSelectMinutesBlock didSelectMinutesBlock;

@end
