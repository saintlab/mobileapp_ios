//
//  OMNRegisterUserVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUser.h"

@protocol OMNRegisterUserVCDelegate;

@interface OMNRegisterUserVC : UIViewController

@property (nonatomic, weak) id<OMNRegisterUserVCDelegate> delegate;

@end

@protocol OMNRegisterUserVCDelegate <NSObject>

- (void)registerUserVC:(OMNRegisterUserVC *)registerUserVC didRegisterUserWithToken:(NSString *)token;

@end
