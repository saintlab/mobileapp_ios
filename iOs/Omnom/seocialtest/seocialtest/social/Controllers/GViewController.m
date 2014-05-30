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
#import "GRateAlertView.h"

@interface GViewController ()
<GUserInfoVCDelegate>

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
  
  GUserInfoVC *vc = [[GUserInfoVC alloc] init];
  
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
  navVC.transitioningDelegate = _transitionDelegate;
  navVC.modalPresentationStyle = UIModalPresentationCustom;
  vc.delegate = self;
  [self presentViewController:navVC animated:YES completion:nil];
  
}

- (IBAction)scanCardTap:(id)sender {
  
  [[GControllerMediator mediator] showPayInfo];
  
}

- (IBAction)paymentTap:(id)sender {
  [[GControllerMediator mediator] showPaymentScreen];
  return;
  [[[GRateAlertView alloc] initWithBlock:^{
    
    [[GControllerMediator mediator] showPaymentScreen];
    
  }] show];
}

#pragma mark - GUserInfoVCDelegate

- (void)viewController1DidFinish:(GViewController1 *)vc {
  
  [self dismissViewControllerAnimated:YES completion:nil];
  
}

@end
