//
//  OMNWizardVC.h
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OMNWizardVC : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
