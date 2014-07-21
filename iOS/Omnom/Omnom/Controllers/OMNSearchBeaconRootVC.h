//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNSearchBeaconRootVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIButton *button;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title buttons:(NSArray *)buttons;

@end
