//
//  OMNR1VC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@class OMNDecodeBeacon;
@protocol OMNR1VCDelegate;

@interface OMNR1VC : OMNCircleRootVC

@property (nonatomic, weak) id<OMNR1VCDelegate> delegate;

- (instancetype)initWithDecodeBeacon:(OMNDecodeBeacon *)decodeBeacon;

@end

@protocol OMNR1VCDelegate <NSObject>

- (void)r1VCDidFinish:(OMNR1VC *)r1VC;

@end
