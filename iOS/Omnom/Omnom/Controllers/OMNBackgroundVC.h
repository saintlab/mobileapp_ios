//
//  OMNStopRootVC.h
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@interface OMNBackgroundVC : UIViewController

@property (strong, nonatomic, readonly) UIImageView *backgroundView;

@property (strong, nonatomic, readonly) UIView *buttonsBackground;
@property (strong, nonatomic, readonly) UIButton *leftBottomButton;
@property (strong, nonatomic, readonly) UIButton *rightBottomButton;
@property (strong, nonatomic, readonly) NSLayoutConstraint *bottomViewConstraint;

- (void)addBottomButtons;

@end
