//
//  OMNViewController.m
//  OMNMailRuAcquiring
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNMailRuAcquiring.h>

@interface OMNViewController ()

@end

@implementation OMNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)payTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] pay];
}
- (IBAction)registerTap:(id)sender {
  [[OMNMailRuAcquiring acquiring] registerCard:nil expDate:nil cvv:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
