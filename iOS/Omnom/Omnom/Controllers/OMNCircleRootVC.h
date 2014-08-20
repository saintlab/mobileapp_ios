//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNCircleRootVC : OMNBackgroundVC

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIView *foregroundView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleCenterLayout;

@property (nonatomic, assign) BOOL faded;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *circleIcon;
@property (nonatomic, strong) UIImage *circleBackground;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent;

@end
