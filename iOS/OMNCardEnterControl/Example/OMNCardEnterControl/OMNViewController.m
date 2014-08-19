//
//  OMNViewController.m
//  OMNCardEnterControl
//
//  Created by teanet on 07/08/2014.
//  Copyright (c) 2014 teanet. All rights reserved.
//

#import "OMNViewController.h"
#import <OMNCardEnterControl.h>

@interface OMNViewController ()
<OMNCardEnterControlDelegate>

@end

@implementation OMNViewController {
  OMNCardEnterControl *_cardEnterControl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  _cardEnterControl = [[OMNCardEnterControl alloc] init];
  _cardEnterControl.translatesAutoresizingMaskIntoConstraints = NO;
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
  self.view.backgroundColor = [UIColor whiteColor];
  NSDictionary *views =
  @{
    @"cardEnterControl" : _cardEnterControl,
    @"topLayoutGuide" : self.topLayoutGuide,
    };
  
  NSArray *panH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[cardEnterControl]-|" options:0 metrics:nil views:views];
  [self.view addConstraints:panH];

  NSArray *panV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-[cardEnterControl]" options:0 metrics:nil views:views];
  [self.view addConstraints:panV];
  
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  [control endEditing:YES];
}

- (void)cardEnterControlDidRequestScan:(OMNCardEnterControl *)control {
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
