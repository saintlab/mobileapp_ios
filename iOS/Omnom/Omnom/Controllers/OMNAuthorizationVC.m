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
  [self addActionsBoard];
}

- (void)addActionsBoard {
  [self addBottomButtons];
  
  [self.leftBottomButton setImage:[UIImage imageNamed:@"registration_icon_small"] forState:UIControlStateNormal];
  [self.leftBottomButton addTarget:self action:@selector(registerTap:) forControlEvents:UIControlEventTouchUpInside];
  [self.leftBottomButton setTitle:NSLocalizedString(@"Регистрация", nil) forState:UIControlStateNormal];
  
  [self.rightBottomButton setImage:[UIImage imageNamed:@"login_icon_small"] forState:UIControlStateNormal];
  [self.rightBottomButton addTarget:self action:@selector(loginTap:) forControlEvents:UIControlEventTouchUpInside];
  [self.rightBottomButton setTitle:NSLocalizedString(@"Вход", nil) forState:UIControlStateNormal];

  self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
  NSLayoutConstraint *offsetConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.buttonsBackground attribute:NSLayoutAttributeTop multiplier:1 constant:0.0f];
  [self.view addConstraint:offsetConstraint];
  NSLayoutConstraint *centerConstraint = [NSLayoutConstraint constraintWithItem:self.pageControl attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.buttonsBackground attribute:NSLayoutAttributeCenterX multiplier:1 constant:0.0f];
  [self.view addConstraint:centerConstraint];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  self.bottomViewConstraint.constant = 0.0f;
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
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

  [self.delegate authorizationVCDidReceiveToken:self];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
