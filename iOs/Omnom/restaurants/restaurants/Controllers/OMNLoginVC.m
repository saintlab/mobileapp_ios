//
//  OMNLoginVC.m
//  restaurants
//
//  Created by tea on 08.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNLoginVC.h"
#import "OMNEditCell.h"
#import "GRestaurantsVC.h"

@interface OMNLoginVC ()
<UITextFieldDelegate>

@end

@implementation OMNLoginVC {
  NSString *_login;
  NSString *_password;
}

- (instancetype)init {
  self = [super initWithStyle:UITableViewStyleGrouped];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];
  self.tableView.tableFooterView = [[UIView alloc] init];
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Войти" style:UIBarButtonItemStylePlain target:self action:@selector(handleLogin)];
}

- (void)handleLogin {
  GRestaurantsVC *restaurantsVC = [[GRestaurantsVC alloc] init];
  [self.navigationController pushViewController:restaurantsVC animated:YES];
  NSLog(@"%@ %@", _login, _password);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"editCellIdentifier";
  
  OMNEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  if (nil == cell) {
    cell = [[OMNEditCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    cell.textField.returnKeyType = UIReturnKeyDone;
    cell.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    cell.textField.autocorrectionType = UITextAutocorrectionTypeNo;
  }

  cell.textField.tag = indexPath.row;
  
  switch (indexPath.row) {
    case 0: {
      cell.textField.text = _login;
      cell.textField.keyboardType = UIKeyboardTypeDefault;
      cell.textField.secureTextEntry = NO;
      cell.textField.delegate = self;
      cell.textLabel.text = @"Login";
    } break;
    case 1: {
      cell.textField.text = _password;
      cell.textField.secureTextEntry = YES;
      cell.textField.delegate = self;
      cell.textLabel.text = @"Password";
    } break;
  }
  
  return cell;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
  switch (textField.tag) {
    case 0: {
      _login = textField.text;
    } break;
    case 1: {
      _password = textField.text;
    } break;
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  [self handleLogin];
  return YES;
}

@end
