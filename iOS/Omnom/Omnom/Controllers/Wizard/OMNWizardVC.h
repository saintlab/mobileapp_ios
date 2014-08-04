//
//  OMNWizardVC.h
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNWizardVC : OMNBackgroundVC

@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
