//
//  OMNSelectTipsAlertVC.h
//  omnom
//
//  Created by tea on 12.05.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"

typedef void(^OMNSelectTipsBlock)(NSInteger amount);

@interface OMNSelectTipsAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNSelectTipsBlock didSelectTipsBlock;

- (instancetype)initWithTotalAmount:(long long)totalAmount;

@end
