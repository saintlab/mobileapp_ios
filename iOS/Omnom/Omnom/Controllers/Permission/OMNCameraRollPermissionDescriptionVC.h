//
//  OMNCameraRollPermissionDescriptionVC.h
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNCircleRootVC.h"

@protocol OMNCameraRollPermissionDescriptionVCDelegate;

@interface OMNCameraRollPermissionDescriptionVC : OMNCircleRootVC

@property (nonatomic, weak) id <OMNCameraRollPermissionDescriptionVCDelegate> delegate;

@end

@protocol OMNCameraRollPermissionDescriptionVCDelegate <NSObject>

- (void)cameraRollPermissionDescriptionVCDidReceivePermission:(OMNCameraRollPermissionDescriptionVC *)cameraRollPermissionDescriptionVC;

@end