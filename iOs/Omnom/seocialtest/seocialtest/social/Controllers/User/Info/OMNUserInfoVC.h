//
//  OMNUserInfoVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNUserInfoVCDelegate;

@interface OMNUserInfoVC : UIViewController

@property (nonatomic, weak) id<OMNUserInfoVCDelegate> delegate;

@end

@protocol OMNUserInfoVCDelegate <NSObject>

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC;

@end