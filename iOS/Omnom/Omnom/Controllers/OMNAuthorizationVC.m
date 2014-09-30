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
#import "OMNToolbarButton.h"
#import "UIImage+omn_helper.h"
#import "OMNAnalitics.h"

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
  page2.text = NSLocalizedString(@"Вызвать официанта\nв любой момент", nil);
  
  OMNWizardPageVC *page3 = [[OMNWizardPageVC alloc] init];
  page3.bgImageName = @"blue_color_wood_bg";
  page3.iconName = @"split_bill_icon_big";
  page3.text = NSLocalizedString(@"Разделить счёт между друзьями", nil);
  
  self = [super initWithViewControllers:@[page1, page2, page3]];
  if (self) {
    __weak typeof(self)weakSelf = self;
    self.buttonInfo =
    @[
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Регистрация", nil) image:[UIImage imageNamed:@"user_settings_icon"] block:^{
        
        [weakSelf registerTap:nil];
        
      }],
      [OMNBarButtonInfo infoWithTitle:NSLocalizedString(@"Вход", nil) image:[UIImage imageNamed:@"login_icon_small"] block:^{
        
        [weakSelf loginTap:nil];
        
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
  [self.navigationController setNavigationBarHidden:YES animated:animated];
  
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  [UIView animateWithDuration:0.3 animations:^{
    [self.view layoutIfNeeded];
  }];
  
}

- (IBAction)loginTap:(id)sender {
  
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

- (void)authorizationVC:(UIViewController *)authorizationVC didReceiveToken:(NSString *)token fromRegstration:(BOOL)fromRegstration {
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] updateAuthenticationToken:token withBlock:^(BOOL tokenIsValid) {
    
    if (fromRegstration) {
      [[OMNAnalitics analitics] logRegister];
    }
    else {
      [[OMNAnalitics analitics] logLogin];
    }
    [weakSelf processAuthorisation];
    
  }];
  
}

- (void)processAuthorisation {
  
  [self dismissViewControllerAnimated:NO completion:^{
    [self.delegate authorizationVCDidReceiveToken:self];
  }];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
