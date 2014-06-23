//
//  OMNUserInfoVC.m
//  seocialtest
//
//  Created by tea on 09.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNUserInfoVC.h"
#import "OMNAuthorisation.h"
#import "OMNUser.h"

@interface OMNUserInfoVC ()

@property (nonatomic, strong) OMNUser *user;

@end

@implementation OMNUserInfoVC {
  
  __weak IBOutlet UILabel *_nameLabel;
  __weak IBOutlet UILabel *_phoneLabel;
  __weak IBOutlet UILabel *_emailLabel;
  __weak IBOutlet UIActivityIndicatorView *_spinner;
  
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

  _spinner.hidesWhenStopped = YES;
  [_spinner startAnimating];
  
  __weak typeof(self)weakSelf = self;
  [OMNUser userWithToken:[OMNAuthorisation authorisation].token user:^(OMNUser *user) {
  
    weakSelf.user = user;
    
  } failure:^(NSError *error) {
    
    [[[UIAlertView alloc] initWithTitle:error.localizedDescription message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles:nil] show];
    
  }];
  
}

- (void)setUser:(OMNUser *)user {
  
  _user = user;
  _nameLabel.text = _user.name;
  _phoneLabel.text = _user.phone;
  _emailLabel.text = _user.email;
  [_spinner stopAnimating];
  
}

- (IBAction)settingsTap:(id)sender {
  
  [self.delegate userInfoVCDidFinish:self];
  
}

- (IBAction)vkTap:(id)sender {
}

- (IBAction)twitterTap:(id)sender {
}

- (IBAction)facebookTap:(id)sender {
}


@end
