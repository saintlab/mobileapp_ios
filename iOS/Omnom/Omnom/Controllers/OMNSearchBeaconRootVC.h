//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNSearchBeaconRootVC : OMNBackgroundVC

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *foregroundView;
@property (nonatomic, copy) dispatch_block_t actionBlock;

@property (nonatomic, strong) UIImage *circleIcon;
@property (nonatomic, strong) UIImage *circleBackground;

- (instancetype)initWithTitle:(NSString *)title buttons:(NSArray *)buttons;

@end
