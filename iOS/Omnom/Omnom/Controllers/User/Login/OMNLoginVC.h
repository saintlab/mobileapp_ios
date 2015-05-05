//
//  OMNLoginVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <PromiseKit.h>

@interface OMNLoginVC : UIViewController

@property (nonatomic, copy) NSString *phone;

- (PMKPromise *)requestLogin:(UIViewController *)rootVC;

@end

