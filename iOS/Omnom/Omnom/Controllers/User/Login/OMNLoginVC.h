//
//  OMNLoginVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationDelegate.h"

@interface OMNLoginVC : UIViewController

@property (nonatomic, weak) id<OMNAuthorizationDelegate> delegate;
@property (nonatomic, copy) NSString *phone;

@end

