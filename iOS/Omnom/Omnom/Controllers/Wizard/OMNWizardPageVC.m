//
//  OMNWizardPageVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardPageVC.h"
#import <OMNStyler.h>
#import "UIImage+omn_helper.h"

@interface OMNWizardPageVC ()

@end

@implementation OMNWizardPageVC {
   
  __weak IBOutlet UILabel *_textLabel;
  __weak IBOutlet UIButton *_circleButton;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNStyle *style = [[OMNStyler styler] styleForClass:self.class];
  self.view.backgroundColor = [UIColor clearColor];
  
  if (self.bgImageName) {
    UIImage *image = [[UIImage imageNamed:self.bgImageName] omn_blendWithColor:self.bgColor];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.image = image;
  }
  
  if (self.iconName) {
    [_circleButton setImage:[UIImage imageNamed:self.iconName] forState:UIControlStateNormal];
  }
  
  _textLabel.text = self.text;
  _textLabel.numberOfLines = 0;
  _textLabel.textColor = [style colorForKey:@"labelTextColor"];
  _textLabel.font = [style fontForKey:@"labelFont"];
}

@end
