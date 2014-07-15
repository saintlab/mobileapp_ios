//
//  GRateAlertView.h
//  seocialtest
//
//  Created by tea on 15.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GRateAlertView : UIAlertView

- (instancetype)initWithBlock:(dispatch_block_t)block;

@end
