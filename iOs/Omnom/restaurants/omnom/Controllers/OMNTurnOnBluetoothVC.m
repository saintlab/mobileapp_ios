//
//  OMNTurnOnBluetoothVC.m
//  restaurants
//
//  Created by tea on 08.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTurnOnBluetoothVC.h"

@interface OMNTurnOnBluetoothVC ()

@end

@implementation OMNTurnOnBluetoothVC

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
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

@end
