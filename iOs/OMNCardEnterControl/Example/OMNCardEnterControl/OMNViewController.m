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
  _cardEnterControl.center = self.view.center;
  _cardEnterControl.delegate = self;
  [self.view addSubview:_cardEnterControl];
	// Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - OMNCardEnterControlDelegate

- (void)cardEnterControl:(OMNCardEnterControl *)control didEnterCardData:(NSDictionary *)cardData {
  [control endEditing:YES];
  NSLog(@"%@", cardData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
