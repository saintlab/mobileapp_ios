//
//  GUserInfoVC.m
//  seocialtest
//
//  Created by tea on 07.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GUserInfoVC.h"
#import "GLoginDataSource.h"

@interface GUserInfoVC ()

@end

@implementation GUserInfoVC {
  GLoginDataSource *_loginDataSource;
}

- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _loginDataSource = [[GLoginDataSource alloc] init];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(backTap)];
  
  self.tableView.dataSource = _loginDataSource;
  self.tableView.delegate = _loginDataSource;

}

- (void)backTap {
  
  [self.delegate viewController1DidFinish:self];
  
}

@end
