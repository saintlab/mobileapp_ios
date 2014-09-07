//
//  OMNAuthorizationDelegate.h
//  seocialtest
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OMNAuthorizationDelegate <NSObject>

- (void)authorizationVC:(UIViewController *)authorizationVC didReceiveToken:(NSString *)token fromRegstration:(BOOL)fromRegstration;

- (void)authorizationVCDidCancel:(UIViewController *)authorizationVC;

@end
