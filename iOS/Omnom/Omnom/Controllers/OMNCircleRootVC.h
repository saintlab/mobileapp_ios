//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNCircleRootVC : OMNBackgroundVC

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIButton *circleButton;
@property (nonatomic, weak) UIView *foregroundView;
@property (nonatomic, assign) BOOL faded;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) UIImage *circleIcon;
@property (nonatomic, strong) UIImage *circleBackground;

@property (nonatomic, strong) dispatch_block_t didCloseBlock;

- (instancetype)initWithParent:(OMNCircleRootVC *)parent;

@end