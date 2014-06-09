//
//  OMNLoginVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoginVC.h"

@interface OMNLoginVC ()

@end

@implementation OMNLoginVC {
  
  __weak IBOutlet UITextField *_passwordTF;
  __weak IBOutlet UITextField *_loginTF;
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
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Войти", nil) style:UIBarButtonItemStylePlain target:self action:@selector(loginTap)];
  // Do any additional setup after loading the view from its nib.
}

- (void)loginTap {
  
  
  
}

- (IBAction)forgotPasswordTap:(id)sender {
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
