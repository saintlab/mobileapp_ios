//
//  OMNAskNavigationPermissionsVC.h
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNAskNavigationPermissionsVCDelegate;

@interface OMNAskNavigationPermissionsVC : UIViewController

@property (nonatomic, weak) id<OMNAskNavigationPermissionsVCDelegate> delegate;

@end

@protocol OMNAskNavigationPermissionsVCDelegate <NSObject>

- (void)askNavigationPermissionsVCDidGrantPermission:(OMNAskNavigationPermissionsVC *)askNavigationPermissionsVC;

@end
