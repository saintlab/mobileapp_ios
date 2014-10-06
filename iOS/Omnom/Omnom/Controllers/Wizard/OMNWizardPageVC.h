//
//  OMNWizardPageVC.h
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNWizardPageVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) NSString *bgImageName;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, strong) NSString *text;

@end
