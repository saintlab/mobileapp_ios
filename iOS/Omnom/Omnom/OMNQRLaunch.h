//
//  OMNQRLaunch.h
//  omnom
//
//  Created by tea on 17.04.15.
//  Copyright (c) 2015 tea. All rights reserved.
//

#import "OMNLaunch.h"

@interface OMNQRLaunch : OMNLaunch

@property (nonatomic, copy) NSString *qr;
@property (nonatomic, copy) NSString *config;

- (instancetype)initWithQR:(NSString *)qr config:(NSString *)config;

@end
