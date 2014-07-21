//
//  OMNDenyCLPermissionVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNDenyCLPermissionVCDelegate;

@interface OMNDenyCLPermissionVC : UIViewController

@property (nonatomic, weak) id<OMNDenyCLPermissionVCDelegate> delegate;

@end

@protocol OMNDenyCLPermissionVCDelegate <NSObject>

- (void)denyCLPermissionVCDidAskPermission:(OMNDenyCLPermissionVC *)denyCLPermissionVC;

@end
