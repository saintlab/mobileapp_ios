//
//  OMNTablePositionVC.m
//  restaurants
//
//  Created by tea on 03.06.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNTablePositionVC.h"
#import "OMNDevicePositionManager.h"

@interface OMNTablePositionVC ()

@end

@implementation OMNTablePositionVC {
  
  OMNDevicePositionManager *_devicePositionManager;
  
}

- (void)dealloc {
  [_devicePositionManager stop];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_devicePositionManager handleDeviceFaceUpPosition:^{
    
    [weakSelf didPlaceOnTable];
    
  }];

  self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Отмена", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelTap)];
  
}

- (void)cancelTap {
  
  [self.tablePositionDelegate tablePositionVCDidCancel:self];
  
}

- (void)didPlaceOnTable {
  
  [self.tablePositionDelegate tablePositionVCDidPlaceOnTable:self];
  
}

@end
