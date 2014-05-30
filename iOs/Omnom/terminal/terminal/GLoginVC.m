//
//  GViewController.m
//  terminal
//
//  Created by tea on 03.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GLoginVC.h"

@interface GLoginVC ()
<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *_loginTF;
@property (weak, nonatomic) IBOutlet UITextField *_passwordTF;

@end

@implementation GLoginVC

- (void)viewDidLoad {
  [super viewDidLoad];

  
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
