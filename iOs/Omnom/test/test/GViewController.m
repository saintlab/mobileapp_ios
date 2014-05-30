//
//  GViewController.m
//  test
//
//  Created by tea on 19.02.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GViewController.h"

@interface GViewController ()

@end

@implementation GViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  
  
  
  return YES;
}

@end
