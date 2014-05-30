//
//  GTableVC.m
//  beacon
//
//  Created by tea on 05.03.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "GTableVC.h"
#import "GBeaconForegroundManager.h"
#import "OMNBeacon.h"
#import "GMenuVC.h"

@interface GTableVC ()

@end

@implementation GTableVC {
  
  OMNBeacon *_beacon;
  BOOL _orderPerformed;
  
}

- (instancetype)initWithBeacon:(OMNBeacon *)beacon {
  self = [super init];
  if (self) {
    _beacon = beacon;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"Back") style:UIBarButtonItemStylePlain target:self action:@selector(backTap)];
  
  UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
  [menuButton setTitle:NSLocalizedString(@"Load menu", @"Load menu") forState:UIControlStateNormal];
  [menuButton addTarget:self action:@selector(menuTap) forControlEvents:UIControlEventTouchUpInside];
  menuButton.center = self.view.center;
  [self.view addSubview:menuButton];
  
  
  
//  self.navigationItem.title = NSLocalizedString(@"Ta", <#comment#>)
  
}

- (void)backTap {
  
  [_beacon removeFromTable];
  [self.delegate tableVCDidFinish:self];
  
}

- (void)menuTap {
  
  GMenuVC *menuVC = [[GMenuVC alloc] init];
  [self.navigationController pushViewController:menuVC animated:YES];
  
}


@end
