//
//  OMNUserInfoVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoVC.h"
#import "OMNLoginVC.h"
#import "OMNRegisterUserVC.h"

@implementation OMNUserInfoVC {
  
}

- (instancetype)init {
  self = [super initWithNibName:@"OMNUserInfoVC" bundle:nil];
  if (self) {
    
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(settingsTap:)];
  
}

- (IBAction)settingsTap:(id)sender {
}


- (IBAction)loginTap:(id)sender {
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  [self.navigationController pushViewController:loginVC animated:YES];
  
}

- (IBAction)registerTap:(id)sender {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  [self.navigationController pushViewController:registerUserVC animated:YES];
  
}

- (IBAction)vkTap:(id)sender {
}

- (IBAction)twitterTap:(id)sender {
}

- (IBAction)facebookTap:(id)sender {
}


@end
