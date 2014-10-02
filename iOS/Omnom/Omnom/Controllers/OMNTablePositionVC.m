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
  _devicePositionManager = nil;
}

- (instancetype)initWithParent:(OMNCircleRootVC *)parent {
  self = [super initWithParent:parent];
  if (self) {
    self.faded = YES;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  _devicePositionManager = [[OMNDevicePositionManager alloc] init];
  
  __weak typeof(self)weakSelf = self;
  [_devicePositionManager handleDeviceFaceUpPosition:^{
    
    [weakSelf didPlaceOnTable];
    
  }];
  
}

- (void)cancelTap {
  
  [self.tablePositionDelegate tablePositionVCDidCancel:self];
  
}

- (void)didPlaceOnTable {
  
  [self.tablePositionDelegate tablePositionVCDidPlaceOnTable:self];
  
}

@end
