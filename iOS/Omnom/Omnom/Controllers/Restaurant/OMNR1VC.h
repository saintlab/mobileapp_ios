//
//  OMNR1VC.h
//  omnom
//
//  Created by tea on 24.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@class OMNVisitor;
@protocol OMNR1VCDelegate;

@interface OMNR1VC : OMNCircleRootVC

@property (nonatomic, weak) id<OMNR1VCDelegate> delegate;
@property (nonatomic, strong, readonly) OMNVisitor *visitor;

- (instancetype)initWithVisitor:(OMNVisitor *)visitor;

- (void)callWaiterDidStart;
- (void)callWaiterDidStop;

@end

@protocol OMNR1VCDelegate <NSObject>

- (void)r1VCDidFinish:(OMNR1VC *)r1VC;

@end
