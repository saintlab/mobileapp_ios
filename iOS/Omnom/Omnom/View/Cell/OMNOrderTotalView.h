//
//  OMNOrderTotalView.h
//  omnom
//
//  Created by tea on 10.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNOrder.h"

extern NSString * const OMNOrderTotalViewIdentifier;

@interface OMNOrderTotalView : UITableViewHeaderFooterView

@property (nonatomic, strong) OMNOrder *order;

@end
