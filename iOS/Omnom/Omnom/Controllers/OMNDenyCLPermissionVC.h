//
//  OMNDenyCLPermissionVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNCircleRootVC.h"

@protocol OMNDenyCLPermissionVCDelegate;

@interface OMNDenyCLPermissionVC : OMNCircleRootVC

@property (nonatomic, weak) id<OMNDenyCLPermissionVCDelegate> delegate;

@end

@protocol OMNDenyCLPermissionVCDelegate <NSObject>

- (void)denyCLPermissionVCDidAskPermission:(OMNDenyCLPermissionVC *)denyCLPermissionVC;

@end
