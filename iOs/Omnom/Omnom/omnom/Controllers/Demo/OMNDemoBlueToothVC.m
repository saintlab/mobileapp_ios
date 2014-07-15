//
//  OMNDemoBlueToothVC.m
//  restaurants
//
//  Created by tea on 14.04.14.
//  Copyright (c) 2014 tea. All rights reserved.
//

#import "OMNDemoBlueToothVC.h"
#import "OMNRestaurantsVC.h"
#import "OMNBeaconTableVC.h"

@interface OMNDemoBlueToothVC ()

@end

@implementation OMNDemoBlueToothVC {
  
  
  
}


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:@"OMNDemoBlueToothVC" bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  
}

- (IBAction)startTap:(id)sender {
  
  if (self.beaconEnabled) {
    
    OMNBeaconTableVC *beaconTableVC = [[OMNBeaconTableVC alloc] init];
    [self.navigationController setViewControllers:@[beaconTableVC] animated:YES];
    
  }
  else {
    
    OMNRestaurantsVC *restaurantsVC = [[OMNRestaurantsVC alloc] init];
    restaurantsVC.title = @"Рестораны";
    [self.navigationController setViewControllers:@[restaurantsVC] animated:YES];
    
  }
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}



@end
