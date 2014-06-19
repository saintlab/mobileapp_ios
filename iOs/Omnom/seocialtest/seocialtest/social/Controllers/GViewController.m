//
//  GViewController.m
//  seocialtest
//
//  Created by tea on 06.05.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GViewController.h"
#import "GAuthManager.h"
#import "GUserInfoTransitionDelegate.h"
#import "GViewController1.h"
#import "GUserInfoVC.h"
#import "GControllerMediator.h"
#import <BlocksKit+UIKit.h>
#import "OMNUserInfoVC.h"

@interface GViewController ()
<OMNUserInfoVCDelegate>

@end

@implementation GViewController {
  GUserInfoTransitionDelegate *_transitionDelegate;

}

- (void)viewDidLoad
{
    [super viewDidLoad];

  _transitionDelegate = [[GUserInfoTransitionDelegate alloc] init];
  
  [[GControllerMediator mediator] setRootViewController:self];
//  GLoginDataSource *
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)open:(id)sender {
  
  OMNUserInfoVC *vc = [[OMNUserInfoVC alloc] init];
  vc.delegate = self;
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
  navVC.transitioningDelegate = _transitionDelegate;
  navVC.modalPresentationStyle = UIModalPresentationCustom;
  [self presentViewController:navVC animated:YES completion:nil];
  
}

#pragma mark - OMNUserInfoVCDelegate

- (void)userInfoVCDidFinish:(OMNUserInfoVC *)userInfoVC {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

- (IBAction)scanCardTap:(id)sender {
  
  [[GControllerMediator mediator] showPayInfo];
  
}

- (IBAction)paymentTap:(id)sender {

  [[GControllerMediator mediator] showPaymentScreen];

}

#pragma mark - GUserInfoVCDelegate

- (void)viewController1DidFinish:(GViewController1 *)vc {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

@end
