//
//  OMNVisitorFactory.h
//  omnom
//
//  Created by tea on 03.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNVisitor.h"

@interface OMNVisitorFactory : NSObject

+ (OMNVisitor *)visitorForRestaurant:(OMNRestaurant *)restaurant;

@end
