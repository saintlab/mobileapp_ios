//
//  OMNStopRootVC.h
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@interface OMNBackgroundVC : UIViewController

@property (strong, nonatomic, readonly) UIImageView *backgroundView;
@property (nonatomic, strong) UIImage *backgroundImage;

@property (strong, nonatomic, readonly) UIToolbar *bottomToolbar;
@property (strong, nonatomic, readonly) NSLayoutConstraint *bottomViewConstraint;

@property (nonatomic, strong) NSArray *buttonInfo;

- (void)addBottomButtons;

@end
