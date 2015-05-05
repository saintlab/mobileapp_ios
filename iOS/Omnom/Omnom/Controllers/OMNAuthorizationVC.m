//
//  OMNStartVC.m
//  restaurants
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNAuthorizationVC.h"
#import "OMNLoginVC.h"
#import "OMNRegisterUserVC.h"
#import "OMNAuthorization.h"
#import "OMNWizardPageVC.h"
#import "OMNToolbarButton.h"
#import "UIImage+omn_helper.h"
#import "OMNAnalitics.h"
#import <OMNStyler.h>

@implementation OMNAuthorizationVC

- (instancetype)init {
  
  OMNWizardPageVC *page1 = [[OMNWizardPageVC alloc] init];
  page1.bgImageName = @"wood_bg";
  page1.bgColor = colorWithHexString(@"CE1200");
  page1.iconName = @"credit_cards_icon_big";
  page1.text = kOMN_WIZZARD_TEXT_1;
  
  OMNWizardPageVC *page2 = [[OMNWizardPageVC alloc] init];
  page2.bgImageName = @"wood_bg";
  page2.bgColor = colorWithHexString(@"089E7D");
  page2.iconName = @"bell_ringing_icon_big";
  page2.text = kOMN_WIZZARD_TEXT_2;

  OMNWizardPageVC *page3 = [[OMNWizardPageVC alloc] init];
  page3.bgImageName = @"wood_bg";
  page3.bgColor = colorWithHexString(@"266BA6");
  page3.iconName = @"split_bill_icon_big";
  page3.text = kOMN_WIZZARD_TEXT_3;
  
  self = [super initWithViewControllers:@[page1, page2, page3]];
  if (self) {
    @weakify(self)
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:kOMN_REGISTER_BUTTON_TITLE image:[UIImage imageNamed:@"user_settings_icon"] block:^{
        
        @strongify(self)
        [self registerTap:nil];
        
      }],
      [OMNBarButtonInfo infoWithTitle:kOMN_LOGIN_BUTTON_TITLE image:[UIImage imageNamed:@"login_icon_small"] block:^{
        
        @strongify(self)
        [self loginTap:nil];
        
      }]
      ];
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addActionsBoard];
}

- (void)addActionsBoard {
  [self addActionBoardIfNeeded];
  
  self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomToolbar attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f]];
  
  [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.bottomToolbar attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0f]];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (IBAction)loginTap:(id)sender {
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
  
}

- (IBAction)registerTap:(id)sender {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerUserVC] animated:YES completion:nil];
  
}

#pragma mark - OMNAuthorizationDelegate

- (void)authorizationVCDidCancel:(UIViewController *)authorizationVC {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)authorizationVC:(UIViewController *)authorizationVC didReceiveToken:(NSString *)token fromRegstration:(BOOL)fromRegstration {
  
  [[OMNAuthorization authorization] setAuthenticationToken:token].finally(^{
    
    [[OMNAnalitics analitics] logUserLoginWithRegistration:fromRegstration];
    [self processAuthorization];

  });

}

- (void)processAuthorization {
  [self dismissViewControllerAnimated:NO completion:self.didFinishBlock];
}

@end
