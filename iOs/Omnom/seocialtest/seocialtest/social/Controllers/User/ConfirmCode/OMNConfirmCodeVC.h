//
//  OMNConfirmCodeVC.h
//  restaurants
//
//  Created by tea on 17.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@protocol OMNConfirmCodeVCDelegate;

@interface OMNConfirmCodeVC : UIViewController

@property (nonatomic, weak) id<OMNConfirmCodeVCDelegate> delegate;

- (instancetype)initWithPhone:(NSString *)phone;

- (void)resetAnimated:(BOOL)animated;

@end


@protocol OMNConfirmCodeVCDelegate <NSObject>

- (void)confirmCodeVC:(OMNConfirmCodeVC *)confirmCodeVC didEnterCode:(NSString *)code;

@end