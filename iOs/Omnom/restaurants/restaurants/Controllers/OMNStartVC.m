//
//  OMNStartVC.m
//  restaurants
//
//  Created by tea on 20.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNStartVC.h"
#import "OMNLoginVC.h"
#import "OMNRegisterUserVC.h"
#import "OMNSearchTableVC.h"
#import "OMNRestaurantMenuVC.h"
#import "OMNAuthorisation.h"
#import "OMNWizardPageVC.h"

@interface OMNStartVC ()
<OMNAuthorizationDelegate,
OMNRestaurantMenuVCDelegate>

@end

@implementation OMNStartVC

- (instancetype)init {
  
  OMNWizardPageVC *page1 = [[OMNWizardPageVC alloc] init];
  page1.bgImageName = @"wizard_menu_image";
  page1.bgColor = [UIColor colorWithRed:64 / 255. green:174 / 255. blue:94 / 255. alpha:1];
  page1.text = NSLocalizedString(@"Меню любимых ресторанов", nil);
  
  OMNWizardPageVC *page2 = [[OMNWizardPageVC alloc] init];
  page2.bgColor = [UIColor colorWithRed:29 / 255. green:130 / 255. blue:187 / 255. alpha:1];
  page2.text = NSLocalizedString(@"Счет и его разделение", nil);
  
  OMNWizardPageVC *page3 = [[OMNWizardPageVC alloc] init];
  page3.bgColor = [UIColor colorWithRed:237 / 255. green:152 / 255. blue:49 / 255. alpha:1];
  page3.text = NSLocalizedString(@"Оплата в любой момент", nil);
  
  OMNWizardPageVC *page4 = [[OMNWizardPageVC alloc] init];
  page4.bgColor = [UIColor colorWithRed:238 / 255. green:61 / 255. blue:70 / 255. alpha:1];
  page4.text = NSLocalizedString(@"Чай по карте", nil);
  
  self = [super initWithViewControllers:@[page1, page2, page3, page4]];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.loginButton addTarget:self action:@selector(loginTap:) forControlEvents:UIControlEventTouchUpInside];
  [self.registerButton addTarget:self action:@selector(registerTap:) forControlEvents:UIControlEventTouchUpInside];
  
  __weak typeof(self)weakSelf = self;
  [[OMNAuthorisation authorisation] checkTokenWithBlock:^(BOOL tokenIsValid) {

    if (tokenIsValid) {
      [weakSelf processAuthorisation];
    }
    
  }];
  
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
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [[OMNAuthorisation authorisation] updateToken:token];
  [self processAuthorisation];
  
}

- (void)processAuthorisation {
  
  __weak typeof(self)weakSelf = self;
  OMNSearchTableVC *searchTableVC = [[OMNSearchTableVC alloc] initWithBlock:^(OMNDecodeBeacon *decodeBeacon) {
    
    if (decodeBeacon) {
      
      [weakSelf didFindBeacon:decodeBeacon];
      
    }
    
  }];
  
  [self.navigationController pushViewController:searchTableVC animated:YES];
  
}

- (void)didFindBeacon:(OMNDecodeBeacon *)decodeBeacon {
  
  //TODO: get actual restaurant
  NSDictionary *data = @{@"id" : decodeBeacon.restaurantId};
  OMNRestaurant *restaurant = [[OMNRestaurant alloc] initWithData:data];
  OMNRestaurantMenuVC *restaurantMenuVC = [[OMNRestaurantMenuVC alloc] initWithRestaurant:restaurant table:nil];
  restaurantMenuVC.delegate = self;
  [self.navigationController pushViewController:restaurantMenuVC animated:YES];
  
}

#pragma mark - OMNRestaurantMenuVCDelegate

- (void)restaurantMenuVCDidFinish:(OMNRestaurantMenuVC *)restaurantMenuVC {
  [self.navigationController popToViewController:self animated:YES];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
