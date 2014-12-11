//
//  GTipSelector.h
//  seocialtest
//
//  Created by tea on 20.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNOrder.h"

#define kDefaultTipSelectedIndex 1

@interface OMNTipSelector : UIControl

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign, readonly) NSInteger previousSelectedIndex;

@property (nonatomic, strong) OMNOrder *order;

@end
