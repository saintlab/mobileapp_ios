//
//  OMNWebVC.h
//  omnom
//
//  Created by tea on 08.12.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OMNUser.h"

@protocol OMNChangePhoneWebVCDelegate;

@interface OMNChangePhoneWebVC : UIViewController

@property (nonatomic, weak) id<OMNChangePhoneWebVCDelegate> delegate;

- (instancetype)initWithUser:(OMNUser *)user;

@end

@protocol OMNChangePhoneWebVCDelegate <NSObject>

- (void)changePhoneWebVCDidChangePhone:(OMNChangePhoneWebVC *)changePhoneWebVC;

@end