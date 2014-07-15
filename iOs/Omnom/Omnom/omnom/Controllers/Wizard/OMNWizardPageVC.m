//
//  OMNWizardPageVC.m
//  restaurants
//
//  Created by tea on 26.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNWizardPageVC.h"
#import "OMNConstants.h"
@interface OMNWizardPageVC ()

@end

@implementation OMNWizardPageVC {
  
  __weak IBOutlet UIImageView *_iv;
  __weak IBOutlet UILabel *_textLabel;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _iv.contentMode = UIViewContentModeTop;
  _iv.image = [UIImage imageNamed:self.bgImageName];
  
  self.view.backgroundColor = self.bgColor;
  
  _textLabel.text = self.text;
  _textLabel.textColor = [UIColor whiteColor];
  _textLabel.font = FuturaBookFont(20);
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
