//
//  OMNWizardPageVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardPageVC.h"
#import <OMNStyler.h>

@interface OMNWizardPageVC ()

@end

@implementation OMNWizardPageVC {
   
  __weak IBOutlet UIImageView *_iv;
  __weak IBOutlet UILabel *_textLabel;
  __weak IBOutlet UIButton *_circleButton;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  OMNStyle *style = [[OMNStyler styler] styleForClass:self.class];
  
  if (self.bgImageName) {
    _iv.contentMode = UIViewContentModeTop;
    _iv.image = [UIImage imageNamed:self.bgImageName];
  }
  
  if (self.iconName) {
    [_circleButton setImage:[UIImage imageNamed:self.iconName] forState:UIControlStateNormal];
  }
  
  if (self.bgColor) {
    self.view.backgroundColor = self.bgColor;
  }
  
  _textLabel.text = self.text;
  _textLabel.numberOfLines = 0;
  _textLabel.textColor = [style colorForKey:@"labelTextColor"];
  _textLabel.font = [style fontForKey:@"labelFont"];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
