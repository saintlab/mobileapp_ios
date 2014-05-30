//
//  GUserInfoVC.h
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GUserInfoVCDelegate;

@interface GUserInfoVC : UITableViewController

@property (nonatomic, weak) id<GUserInfoVCDelegate> delegate;

@end

@protocol GUserInfoVCDelegate <NSObject>

- (void)viewController1DidFinish:(GUserInfoVC *)vc;

@end