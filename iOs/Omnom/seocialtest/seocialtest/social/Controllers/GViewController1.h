//
//  GViewController1.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GViewController1Delegate;

@interface GViewController1 : UIViewController

@property (nonatomic, weak) id<GViewController1Delegate> delegate;

@end

@protocol GViewController1Delegate <NSObject>

- (void)viewController1DidFinish:(GViewController1 *)vc;

@end

