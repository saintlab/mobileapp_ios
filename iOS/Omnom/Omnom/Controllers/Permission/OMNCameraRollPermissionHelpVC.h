//
//  OMNCameraRollPermissionHelpVC.h
//  omnom
//
//  Created by tea on 05.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNPermissionHelpVC.h"

@protocol OMNCameraRollPermissionHelpVCDelegate;

@interface OMNCameraRollPermissionHelpVC : OMNPermissionHelpVC

@property (nonatomic, weak) id <OMNCameraRollPermissionHelpVCDelegate> delegate;

@end


@protocol OMNCameraRollPermissionHelpVCDelegate <NSObject>

- (void)cameraRollPermissionHelpVCDidReceivePermission:(OMNCameraRollPermissionHelpVC *)cameraRollPermissionHelpVC;

@end