//
//  OMNLunchOrderAlertVC.h
//  omnom
//
//  Created by tea on 25.03.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNModalAlertVC.h"
#import "OMNVisitor.h"

typedef void(^OMNDidSelectVisitorBlock)(OMNVisitor *visitor);

@interface OMNLunchOrderAlertVC : OMNModalAlertVC

@property (nonatomic, copy) OMNDidSelectVisitorBlock didSelectVisitorBlock;

- (instancetype)initWithRestaurant:(OMNRestaurant *)restaurant;

@end
