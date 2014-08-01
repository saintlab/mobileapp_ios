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
#import "OMNAuthorisation.h"
#import "OMNWizardPageVC.h"
#import "OMNConstants.h"

@interface OMNAuthorizationVC ()
<OMNAuthorizationDelegate>

@end

@implementation OMNAuthorizationVC

- (instancetype)init {
  
  OMNWizardPageVC *page1 = [[OMNWizardPageVC alloc] init];
  page1.bgImageName = @"red_color_wood_bg";
  page1.iconName = @"credit_cards_icon_big";
  page1.text = NSLocalizedString(@"Оплатить счёт через телефон", nil);
  
  OMNWizardPageVC *page2 = [[OMNWizardPageVC alloc] init];
  page2.bgImageName = @"green_color_wood_bg";
  page2.iconName = @"bell_ringing_icon_big";
  page2.text = NSLocalizedString(@"Вызвать официанта в любой момент", nil);
  
  OMNWizardPageVC *page3 = [[OMNWizardPageVC alloc] init];
  page3.bgImageName = @"blue_color_wood_bg";
  page3.iconName = @"split_bill_icon_big";
  page3.text = NSLocalizedString(@"Разделить счёт между друзьями", nil);
  
  self = [super initWithViewControllers:@[page1, page2, page3]];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.loginButton addTarget:self action:@selector(loginTap:) forControlEvents:UIControlEventTouchUpInside];
  [self.registerButton addTarget:self action:@selector(registerTap:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)loginTap:(id)sender {
  
  if (kUseStubLogin) {
    [self processAuthorisation];
    return;
  }
  
  OMNLoginVC *loginVC = [[OMNLoginVC alloc] init];
  loginVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:loginVC] animated:YES completion:nil];
  
}

- (IBAction)registerTap:(id)sender {
  
  OMNRegisterUserVC *registerUserVC = [[OMNRegisterUserVC alloc] init];
  registerUserVC.delegate = self;
  [self presentViewController:[[UINavigationController alloc] initWithRootViewController:registerUserVC] animated:YES completion:nil];
  
}

#pragma mark - OMNAuthorizationDelegate

- (void)authorizationVCDidCancel:(UIViewController *)authorizationVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (void)authorizationVC:(UIViewController *)authorizationVC didReceiveToken:(NSString *)token {
  
  [[OMNAuthorisation authorisation] updateAuthenticationToken:token];
  [self dismissViewControllerAnimated:NO completion:^{
    [self processAuthorisation];
  }];
  
}

- (void)processAuthorisation {

  [self.delegate startVCDidReceiveToken:self];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
