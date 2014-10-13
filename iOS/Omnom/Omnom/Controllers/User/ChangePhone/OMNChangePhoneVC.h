//
//  OMNChangePhoneVC.h
//  omnom
//
//  Created by tea on 13.10.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OMNChangePhoneVCDelegate;

@interface OMNChangePhoneVC : UIViewController

@property (nonatomic, weak) id<OMNChangePhoneVCDelegate> delegate;

@end

@protocol OMNChangePhoneVCDelegate <NSObject>

- (void)changePhoneVCDidFinish:(OMNChangePhoneVC *)changePhoneVC;

@end
