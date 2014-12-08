//
//  OMNCameraPermissionVC.h
//  omnom
//
//  Created by tea on 25.11.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNPermissionHelpVC.h"

@protocol OMNCameraPermissionHelpVCDelegate;

@interface OMNCameraPermissionHelpVC : OMNPermissionHelpVC

@property (nonatomic, weak) id <OMNCameraPermissionHelpVCDelegate> delegate;

@end

@protocol OMNCameraPermissionHelpVCDelegate <NSObject>

- (void)cameraPermissionHelpVCDidReceivePermission:(OMNCameraPermissionHelpVC *)cameraPermissionHelpVC;

@end
