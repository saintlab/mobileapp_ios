//
//  OMNSearchBeaconRootVC.h
//  omnom
//
//  Created by tea on 21.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

@interface OMNSearchBeaconRootVC : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *circleButton;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, copy) dispatch_block_t actionBlock;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title buttons:(NSArray *)buttons;

@end
