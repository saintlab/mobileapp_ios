//
//  OMNEditUserVC.h
//  omnom
//
//  Created by tea on 03.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNUser.h"

@protocol OMNEditUserVCDelegate;

@interface OMNEditUserVC : UIViewController

@property (nonatomic, weak) id<OMNEditUserVCDelegate> delegate;

@end

@protocol OMNEditUserVCDelegate <NSObject>

- (void)editUserVCDidFinish:(OMNEditUserVC *)editUserVC;

@end