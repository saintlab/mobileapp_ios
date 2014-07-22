//
//  OMNStartVC.h
//  restaurants
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardVC.h"

@protocol OMNStartVC1Delegate;

@interface OMNStartVC1 : OMNWizardVC

@property (nonatomic, weak) id<OMNStartVC1Delegate> delegate;

@end

@protocol OMNStartVC1Delegate <NSObject>

- (void)startVCDidReceiveToken:(OMNStartVC1 *)startVC;

@end
