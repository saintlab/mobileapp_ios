//
//  OMNLoginVC.h
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNLoginVCDelegate;

@interface OMNLoginVC : UIViewController

@property (nonatomic, weak) id<OMNLoginVCDelegate> delegate;

@end

@protocol OMNLoginVCDelegate <NSObject>

- (void)loginVC:(OMNLoginVC *)loginVC didReceiveToken:(NSString *)token;

@end