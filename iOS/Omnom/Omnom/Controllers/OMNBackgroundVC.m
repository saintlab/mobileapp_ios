//
//  OMNStopRootVC.m
//  omnom
//
//  Created by tea on 25.07.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNBackgroundVC.h"

@interface OMNBackgroundVC ()

@end

@implementation OMNBackgroundVC

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _backgroundView = [[UIImageView alloc] initWithFrame:self.view.bounds];
  [self.view insertSubview:_backgroundView atIndex:0];
  
}

@end
