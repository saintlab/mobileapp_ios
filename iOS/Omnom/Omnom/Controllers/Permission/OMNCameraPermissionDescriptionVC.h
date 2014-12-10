//
//  OMNCameraPermissionDescriptionVC.h
//  omnom
//
//  Created by tea on 10.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNCircleRootVC.h"

@protocol OMNCameraPermissionDescriptionVCDelegate;

@interface OMNCameraPermissionDescriptionVC : OMNCircleRootVC

@property (nonatomic, weak) id <OMNCameraPermissionDescriptionVCDelegate> delegate;

@end

@protocol OMNCameraPermissionDescriptionVCDelegate <NSObject>

- (void)cameraPermissionDescriptionVCDidReceivePermission:(OMNCameraPermissionDescriptionVC *)cameraPermissionDescriptionVC;

@end