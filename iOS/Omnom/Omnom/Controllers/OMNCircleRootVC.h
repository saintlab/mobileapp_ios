//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNCircleRootVC : OMNBackgroundVC

@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIView *foregroundView;
@property (nonatomic, assign) BOOL faded;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *circleIcon;
@property (nonatomic, strong) UIImage *circleBackground;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent;

@end